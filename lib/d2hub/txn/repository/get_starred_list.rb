require_relative '../transaction'

module D2HUB
  class GetStarredRepositories < Transaction
    def run(user_name: nil)
      user = User.find name: user_name
      repo_ids =DB['SELECT repository_id FROM stars WHERE user_id = ?', user[:id]].select_map(:id)
      user.starred_repositories_dataset.where(id: repo_ids).order(:updated_at, :created_at).reverse.all
    end
  end
end