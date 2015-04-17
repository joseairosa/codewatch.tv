namespace :build do
  desc 'Build list of languages'
  task list_of_languages: :environment do
    languages_array = File.read(File.join('lib', 'assets', 'languages.txt')).split("\r\n")
    languages_array.each { |name| Category.find_or_create(name) }
  end

  desc 'reindex for search'
  task search_index: :environment do
    User.all.to_a.each{|c| c.index}
    Category.all.to_a.each{|c| c.index}
    Channel.all.to_a.each{|c| c.index}
  end
end

