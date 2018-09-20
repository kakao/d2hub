require_relative '../transaction'

module D2HUB
  class ExistUser < Transaction
    def run(user_name: nil)
      not User.find(name: user_name).nil?
    end
  end
end