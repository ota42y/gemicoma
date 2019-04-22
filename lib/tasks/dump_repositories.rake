namespace :dump_repositories do
  desc "dump repositories"
  task :dump do
    puts "export export.json"

    d = ::Github::User.dump

    json_file_path = './tmp/export.json'
    open(json_file_path, 'w') do |f|
      JSON.dump(d, f)
    end
  end

  desc "restore from export.json"
  task :restore do
    json_file_path = './tmp/export.json'
    f = open(json_file_path)
    d = JSON.load(f)
    ::Github::User.restore(d.map(&:with_indifferent_access))
  end
end
