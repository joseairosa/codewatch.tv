class Channel
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable

  belongs_to :user
  belongs_to :category

  index title: 1

  field :title,           type: String, default: 'Untitled broadcast'
  field :description,     type: String
  field :total_viewers,   type: Integer, default: 0
  field :current_viewers, type: Integer, default: 0
  field :likes,           type: Integer, default: 0
end
