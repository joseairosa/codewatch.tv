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
end
