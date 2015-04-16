class Channel
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  has_one :category

  index title: 1

  field :title,           type: String
  field :description,     type: String
  field :total_viewers,   type: Integer, default: 0
  field :current_viewers, type: Integer, default: 0
  field :likes,           type: Integer, default: 0
end
