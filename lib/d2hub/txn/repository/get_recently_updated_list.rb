require_relative '../transaction'

module D2HUB
  class GetRecentlyUpdatedRepositories < Transaction
    def run(user_name: nil, count: 4)
      user = User.find name: user_name
      repos = user.repositories_dataset.order(:updated_at, :created_at).reverse.limit(count).all
      repos.select do |repo|
        not (repo.organization.nil?)
      end
    end
  end
end