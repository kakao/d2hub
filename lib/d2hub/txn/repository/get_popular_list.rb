require_relative '../transaction'

module D2HUB
  class GetPopularRepositories < Transaction
    def run(count: 5)
      repo_count_hash = DB[:stars]
      .group_and_count(:repository_id)
      .order(:count).reverse.limit(count)
      .to_hash(:repository_id, :count)

      Repository.where(id: repo_count_hash.keys).where(access_type: 'public').all
    end
  end
end