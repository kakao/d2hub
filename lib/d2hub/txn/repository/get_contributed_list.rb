require_relative '../transaction'

module D2HUB
  class GetContributedRepositories < Transaction
    def run(user_name: nil, count: 5)
      user = User.find name: user_name
      repo_ids = DB[:collaborators].filter(user_id: user[:id], role: 'collaborator').select(:repository_id)
      user.repositories_dataset.where(id: repo_ids).order(:updated_at, :created_at).reverse.limit(count).all
    end
  end
end