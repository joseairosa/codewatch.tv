namespace :build do
  desc 'Build list of languages'
  task list_of_languages: :environment do
    languages_array = YAML.load_file(File.join('lib', 'assets', 'languages.yml'))
    languages_array.each { |name, data|
      category = Category.find_or_create(name)
      category.update_attributes(description: data['description'])
    }
  end

  desc 'reindex for search'
  task search_index: :environment do
    User.all.to_a.each{|c| c.index}
    Category.all.to_a.each{|c| c.index}
    Channel.all.to_a.each{|c| c.index}
  end
end

