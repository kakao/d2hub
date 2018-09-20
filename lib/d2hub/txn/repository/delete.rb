require_relative '../transaction'
require_relative '../user/get_owner_of_repository'
require_relative '../repository/get'
require 'logger'

module D2HUB
  class DeleteRepository < Transaction
    @@logger = Logger.new(STDOUT)
    def run(org_name: nil, repo_name: nil)
      begin
        owner = GetOwnerOfRepository.run org_name: org_name,
                                         repo_name: repo_name
        repo = GetRepository.run org_name: org_name,
                                 repo_name: repo_name
        if owner.nil?
          @@logger.info("Owner not found")
          @@logger.info("DeleteRepository receive, repo : #{repo_name}")
        else
          gh_access_token = D2HUB::get_github_access_token github_host: repo.github_host,
                                                           user_name: owner[:name]
          @@logger.info("DeleteRepository receive owner : #{owner[:name]} / repo : #{repo_name} / gh_access_token : #{gh_access_token}")
          unless gh_access_token.nil?
            repos = GetRepositoriesByGitHubRepoId.run github_repo_id: repo[:github_repo_id]
            if repos.length == 1
              gh_client = D2HUB::create_github_client_by_token github_host: repo.github_host,
                                                               github_access_token: gh_access_token
              gh_client.remove_hook(repo[:github_repo_id], repo[:github_hook_id])
            end
          end
        end

        collabors = GetCollaboratorsFromRepository.run org_name: org_name,
                                                       repo_name: repo_name
        collabors.each do |user|
          user.remove_repository repo
        end

        @@logger.info("DeleteRepository : #{repo.name}")
        repo.destroy
      rescue Exception => e
        @@logger.error("DeleteRepository Failed. org_name : #{org_name} repo_name : #{repo_name} error : #{e}")
        @@logger.error e.backtrace.join("\n")
        return nil
      end
    end
  end
end