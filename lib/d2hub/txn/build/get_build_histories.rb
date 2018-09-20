require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class GetBuildHistories < Transaction
    def run(org_name: nil, repo_name: nil)
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      repo.build_histories_dataset.select(
          :id,
          :repository_id,
          :git_url,
          :git_branch_name,
          :status,
          :dockerfile_content,
          :error_reason,
          :docker_image_name,
          :dockerfile_location,
          :dockerfile_name,
          :dockerbuild_arg,
          :git_type,
          :docker_tag_name,
          :build_tag_id,
          :created_at,
          :updated_at
      ).order(:id).reverse.limit(30)
    end
  end
end