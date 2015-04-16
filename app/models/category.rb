class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  index name: 1

  field :name, type: String

  def self.find_or_create(name)
    found = self.where(name: name)
    if found.count == 0
      found = self.create!(name: name)
    else
      found.first
    end
  end
end