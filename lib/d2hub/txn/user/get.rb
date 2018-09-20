require_relative '../transaction'

module D2HUB
  class GetUser < Transaction
    def run(user_name: nil)
      User.find name: user_name
      # user = User.eager(:repositories).eager(:organizations).eager(:active_feeds)
      # user.first name: user_name
    end
  end
end