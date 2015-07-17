module Concerns
  module Subscription
    def transaction
      transactions.last
    end

    def internal_id
      transaction.data['id']
    end

    def start_date
      Time.at(transaction.data['current_period_start'])
    end

    def end_date
      Time.at(transaction.data['current_period_end'])
    end

    def status
      transaction.data['status']
    end

    def canceled?
      status == 'canceled'
    end

    def amount
      transaction.data['plan']['amount'].to_f/100.0
    end
  end
end
