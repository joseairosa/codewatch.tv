class Recording
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :name,  type: String
  field :views, type: Integer, default: 0
  field :title, type: String

  def new_viewer
    self.views = self.views+1
    save
  end
end
