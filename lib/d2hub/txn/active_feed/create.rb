require_relative '../transaction'

module D2HUB
  class CreateActiveFeed < Transaction
    def run(user_name: nil, action: nil)
      user = User.find name: user_name
      user.add_active_feed action: action
    end
  end
end