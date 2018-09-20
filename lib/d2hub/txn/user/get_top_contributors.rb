require_relative '../transaction'
require_relative '../repository/get_collaborators'

module D2HUB
  class GetTopContributors < Transaction
    def run(count: 5)
      user_count_hash = DB[:collaborators]
      .group_and_count(:user_id)
      .order(:count).reverse.limit(count)
      .to_hash(:user_id, :count)

      users = User.where(id: user_count_hash.keys).all
      users.map do |user|
        user[:repository_count] = user_count_hash[user[:id]]
        user
      end.sort do |user1, user2|
        user2[:repository_count] <=> user1[:repository_count]
      end
    end
  end
end