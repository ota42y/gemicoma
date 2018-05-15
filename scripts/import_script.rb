require 'pg'

dbname = ENV['RUBYGEMS_PG_DATABASE_DBNAME']  || 'gemcutter_development'
user = ENV['RUBYGEMS_PG_DATABASE_USER'] || 'postgres'
port = ENV['RUBYGEMS_PG_DATABASE_PORT'] || 5432
hostaddr = ENV['RUBYGEMS_PG_DATABASE_HOSTADDR'] || 'rubygems_docker_postgres'

# need select * from xxx WHERE .....
# or select * from xxx WHERE xxx yyy AND .....
def find_in_batches(connection, select_from, where, start_id, size)
  n = start_id

  base_query = [select_from]
  if where.nil?
    base_query << 'WHERE'
  else
    base_query << where
    base_query << 'AND'
  end

  loop do
    query = (base_query + ["#{n} < id order by id limit #{size}"]).join(' ')
    ret = connection.exec(query)
    break if ret.count == 0
    last_id = yield ret

    n = last_id ? last_id : n + size
  end
end

def import_versions(conn, pg_rubygem_id_to_name, name_to_mysql_rubygem)
  where = "WHERE rubygem_id in (#{pg_rubygem_id_to_name.keys.map(&:to_i).join(", ")})"
  find_in_batches(conn, 'SELECT * FROM public.versions', where, 0, 500) do |result|
    last_id = nil

    versions = result.map do |version|
      last_id = version['id'].to_i

      rubygem_id = version['rubygem_id'].to_i
      rubygem_name = pg_rubygem_id_to_name[rubygem_id]
      dump_rubygem = name_to_mysql_rubygem[rubygem_name]

      params = {
        dump_rubygems_rubygem: dump_rubygem,
        platform: version['platform'],
        number: version['number'],
      }
      Dump::Rubygems::Version.new(params)
    end

    Rails.logger.info("import #{versions.size} versions")
    Dump::Rubygems::Version.import versions

    last_id
  end
end

# Output a table of current connections to the DB
conn = PG.connect(dbname: dbname, user: user, port: port, hostaddr: hostaddr)

count = 0
find_in_batches(conn, 'SELECT * FROM public.rubygems', nil, 0, 500) do |result|
  count += result.count

  pg_rubygem_id_to_name = {}
  gems = result.map do |row|
    gem = ::Dump::Rubygems::Rubygem.new(name: row['name'], slug: row['slug'])
    pg_rubygem_id_to_name[row['id'].to_i] = gem.name

    gem
  end

  Rails.logger.info("import from #{gems.first.name} to #{gems.last.name}, #{gems.size} gems")
  ::Dump::Rubygems::Rubygem.import gems, on_duplicate_key_update: [:slug]
  name_to_mysql_rubygem = ::Dump::Rubygems::Rubygem.where(name: gems.map(&:name)).map { |g| [g.name, g] }.to_h

  import_versions(conn, pg_rubygem_id_to_name, name_to_mysql_rubygem)

  last_id = pg_rubygem_id_to_name.keys.sort.last
  last_id.zero? ? nil : last_id
end
