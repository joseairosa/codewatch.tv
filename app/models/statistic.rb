class Statistic
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,  type: Symbol
  field :value, type: String
end
