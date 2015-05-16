class Statistic
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :channel
  belongs_to :recording

  field :name,  type: Symbol
  field :value, type: String
end
