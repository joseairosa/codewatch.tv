require 'elasticsearch'

class SearchService

  include Singleton

  def initialize
    config = YAML.load_file("#{Rails.root}/config/search_server.yml")[Rails.env]
    @elastic_client = Elasticsearch::Client.new(host: config['host'], log: true)
  end

  def search(query)
    categories = search_categories(query)
    channels = search_channels(query)
    users = search_users(query)

    categories = categories.map do |category|
      { value: category, data: { category: 'Category' } }
    end

    channels = channels.map do |channel|
      { value: channel[:title], data: { category: 'Channel', user_id: channel[:user_id] } }
    end

    users = users.map do |user|
      { value: user, data: { category: 'User' } }
    end
    {suggestions: categories + channels + users}
  end

  def index(object)
    case (object.class)
      when Channel
        index_channel(object)
      when Category
        index_category(object)
      when User
        index_user(object)
    end
  end

  def search_categories(query)
    response = @elastic_client.search index: 'category', body: {query: {wildcard: {name: query}}}
    hashed = Hashie::Mash.new(response)
    hashed.hits.hits.map { |category| category._source.name }
  end

  def search_channels(query)
    response = @elastic_client.search index: 'channel',
                                      body: {
                                          query: {
                                              dis_max: {
                                                  queries: [
                                                      {wildcard: {title: query}},
                                                      {wildcard: {description: query}},
                                                  ]
                                              }
                                          }
                                      }
    hashed = Hashie::Mash.new(response)
    hashed.hits.hits.map { |channel| {title: channel._source.title, description: channel._source.description, user_id: channel._source.user_id} }
  end

  def search_users(query)
    response = @elastic_client.search index: 'users', body: {query: {wildcard: {name: query}}}
    hashed = Hashie::Mash.new(response)
    hashed.hits.hits.map { |user| user._source.name }
  end

  def index_user(user)
    @elastic_client.index index: 'users', type: 'users', id: user.id, body: {name: user.username}
  end

  def index_channel(channel)
    @elastic_client.index index: 'channel', type: 'channel', id: channel.id, body: {title: channel.title, description: channel.description, user_id: channel.user.username}
  end

  def index_category(category)
    @elastic_client.index index: 'category', type: 'category', id: category.id, body: {name: category.name}
  end
end