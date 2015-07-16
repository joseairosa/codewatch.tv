class AccountType::Admin
  ACCOUNT_TYPES['admin'].each do |method, output|
    define_method(method.to_sym) do
      output
    end
  end
end
