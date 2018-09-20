require_relative '../transaction'
require_relative '../repository/get'

module D2HUB
  class GetComments < Transaction
    def run(org_name: nil, repo_name: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      user_ids = repo.comments.map do |comment|
        comment[:user_id]
      end

      user_id_map = DB[:users].where(id: user_ids).to_hash(:id, :name)

      repo.comments_dataset.order(:created_at).reverse.map do |comment|
        comment[:user_name] = user_id_map[comment[:user_id]]
        comment
      end
      # DB[:comments].where(:users, id: :user_id).order(:created_at).reverse.all
    end
  end
end