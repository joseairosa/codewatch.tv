module Concerns
  module AccountLogic
    def can_access_admin?
      self.account_type.name == :admin
    end
  end
end
