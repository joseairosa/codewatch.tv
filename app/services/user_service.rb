class UserService

  include Singleton

  def initialize

  end

  def make_featured(user)
    user.update(featured: 1)
  end

  def remove_featured(user)
    user.update(featured: 0)
  end

  def change_account_type(user, account_type)
    user.account_type.update!(name: account_type)
  end

  def create_private_session(user, options={})
    PrivateSession.create({user: user}.merge(options))
  end
end
