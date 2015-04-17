class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable

  index name: 1

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
end
