class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  token pattern: "TX-%s%s%s%s%s%s"

  belongs_to :user

  field :source, type: String

  def data
    @data ||= JSON.parse(source)
  end
end
