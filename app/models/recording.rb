class Recording
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :name,  type: String
  field :views, type: Integer, default: 0

end
