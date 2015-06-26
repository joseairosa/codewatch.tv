class Recording
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Streamer
  include Mongoid::Token

  belongs_to :user

  has_many :statistics

  index name: 1

  field :name,            type: String
  field :views,           type: Integer, default: 0
  field :title,           type: String
  field :visible,         type: Integer, default: 1
  field :current_viewers, type: Integer, default: 0
  field :streamer_id,     type: String

  token pattern: "R-%s%s%s%s%s%s"

  after_create :send_statistics

  def new_viewer
    self.views = self.views+1
    save
  end

  def is_visible?
    !self.visible.zero?
  end

  def toggle_visibility
    if self.visible == 1
      self.visible = 0
    else
      self.visible = 1
    end
    save
  end

  private

  def send_statistics
    StatisticService.instance.new_recording(self)
  end
end
