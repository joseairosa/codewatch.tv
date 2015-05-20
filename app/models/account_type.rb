class AccountType
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_TYPE = :free
  ALLOWED_TYPES = [:free, :premium, :admin]

  embedded_in :user

  field :name, type: Symbol, default: DEFAULT_TYPE

  validates_inclusion_of :name, in: ALLOWED_TYPES
end
