require 'securerandom'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Concerns::Searchable
  include Concerns::AccountLogic
  include Gravtastic

  gravtastic :size => 440, default: 'identicon'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_one     :channel
  has_many    :recordings
  has_many    :chats_banned,                class_name: 'ChatUserBanned'
  has_many    :chats_moderator,             class_name: 'ChatUserModerator'
  has_many    :channel_likes,               class_name: 'ChannelLike'
  has_many    :private_sessions,            class_name: 'PrivateSession',     inverse_of: :user
  belongs_to  :private_session_participant, class_name: 'PrivateSession',     inverse_of: :participants
  has_many    :subscriptions,               class_name: 'ChannelSubscriber',  inverse_of: :user
  embeds_one  :account_type

  index 'account_type.name' => 1

  ## Database authenticatable
  field :first_name, type: String, default: ''
  field :last_name, type: String, default: ''
  field :occupation, type: String, default: ''
  field :about_me, type: String, default: ''
  field :email, type: String, default: ''
  field :encrypted_password, type: String, default: ''
  field :username, type: String
  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  field :provider, :type => String
  field :uid, :type => String
  field :timezone, :type => String, default: '(GMT+00:00) UTC'

  # Social
  field :facebook_link, :type => String
  field :twitter_link, :type => String
  field :github_link, :type => String
  field :google_plus_link, :type => String

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count, type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at, type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip, type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :stream_key,  type: String, default: SecureRandom.uuid

  field :featured, type: Integer, default: 0

  field :can_record, type: Integer, default: 0
  validates :can_record, format: {with: /[0-1]/}

  # Stripe
  field :stripe_customer_id, type: String

  index stream_key: 1
  index username: 1

  attr_accessor :login

  after_create :create_channel
  after_create :create_account_type
  after_create :send_statistics

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login).downcase
      where(conditions).where('$or' => [{:username => /^#{Regexp.escape(login)}$/i}, {:email => /^#{Regexp.escape(login)}$/i}]).first
    else
      where(conditions).first
    end
  end

  def self.valid_stream_key?(username, stream_key)
    self.where(username: username, stream_key: stream_key).count == 1
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.email
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.save
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def chat_id
    username
  end

  def can_record?
    !can_record.zero?
  end

  def timezone_offset
    ActiveSupport::TimeZone.all.find { |tz| tz.to_s == timezone }.formatted_offset
  end

  private

  def create_channel
    Channel.create!(user: self)
  end

  def create_account_type
    AccountType.create!(user: self)
  end

  def send_statistics
    StatisticService.instance.new_user(self)
  end
end
