class AccountType
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_TYPE = :free
  ALLOWED_TYPES = [:free, :plus, :admin]

  embedded_in :user

  field :name, type: Symbol, default: DEFAULT_TYPE

  validates_inclusion_of :name, in: ALLOWED_TYPES

  def permissions
    @permissions ||= "AccountType::#{self.name.to_s.capitalize}".constantize.new
  end
end
