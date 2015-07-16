class AccountType::Plus
  ACCOUNT_TYPES['plus'].each do |method, output|
    define_method(method.to_sym) do
      output
    end
  end
end
