class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable

  index name: 1

  has_many :channels, inverse_of: :category

  field :name, type: String

  has_many :channel

  def self.find_or_create(name)
    found = self.where(name: name)
    if found.count == 0
      found = self.create!(name: name)
    else
      found.first
    end
  end

  def dehumanize
    name.gsub('#', 'sharp').gsub('+', 'plus').parameterize.underscore
  end

  def current_viewers
    '0'
  end
end
