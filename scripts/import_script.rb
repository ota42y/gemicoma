require 'pg'

dbname = ENV['RUBYGEMS_PG_DATABASE_DBNAME']
user = ENV['RUBYGEMS_PG_DATABASE_USER']
port = ENV['RUBYGEMS_PG_DATABASE_PORT']
hostaddr = ENV['RUBYGEMS_PG_DATABASE_HOSTADDR']

# need select * from xxx WHERE .....
# or select * from xxx WHERE xxx yyy AND .....
def find_in_batches(connection, select_from, where, start_id, size)
  n = start_id

  where = where.nil? ? 'WHERE' : ''
  base_query = [select_from, where]

  loop do
    query = (base_query + ["#{n} < id order by id limit #{size}"]).join(' ')
    ret = connection.exec(query)
    break if ret.count == 0
    last_id = yield ret

    n = last_id ? last_id : n + size
  end
end

def import_versions(conn, name_to_pg_id, name_to_mysql_id)
  # not yet
end

# Output a table of current connections to the DB
conn = PG.connect(dbname: dbname, user: user, port: port, hostaddr: hostaddr)

count = 0
find_in_batches(conn, 'SELECT * FROM public.rubygems', nil, 0, 500) do |result|
  count += result.count

  name_to_pg_id = {}
  gems = result.map do |row|
    gem = ::Dump::Rubygems::Rubygem.new(name: row['name'], slug: row['slug'])
    name_to_pg_id[gem.name] = row['id'].to_i

    gem
  end

  ::Dump::Rubygems::Rubygem.import gems, on_duplicate_key_update: [:slug]
  name_to_mysql_id = ::Dump::Rubygems::Rubygem.where(name: gems.map(&:name)).pluck(:name, :id).to_h

  import_versions(conn, name_to_pg_id, name_to_mysql_id)

  last_id = name_to_pg_id.values.sort.last
  last_id.zero? ? nil : last_id
end
