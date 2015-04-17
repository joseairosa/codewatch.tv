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

  def new_viewer
    self.current_viewers = self.current_viewers+1
    self.total_viewers = self.total_viewers+1
    save
  end

  def viewer_left
    self.current_viewers = self.current_viewers-1
    save
  end
end
