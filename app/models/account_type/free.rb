class AccountType::Free
  ACCOUNT_TYPES['free'].each do |method, output|
    define_method(method.to_sym) do
      output
    end
  end
end
