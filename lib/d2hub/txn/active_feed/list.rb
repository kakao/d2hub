require_relative '../transaction'

module D2HUB
  class GetActiveFeeds < Transaction
    def run(user_name: nil, count: 10)
      user = User.find name: user_name
      user.active_feeds_dataset.order(:created_at).reverse.limit(count).all
    end
  end
end