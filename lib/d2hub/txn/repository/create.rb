require_relative '../transaction'
require_relative '../user'
require 'base64'

module D2HUB
  class CreateRepository < Transaction
    def run(user_name: nil,
            org_name: nil,
            repo_name: nil,
            short_description: nil,
            description: nil,
            access_type: nil,
            github_host: nil,
            github_repo_id: nil,
            build_tags: nil,
            active_build: nil,
            watch_center_id: nil)
      is_automated_build = !build_tags.nil?

      repo_params = {name: repo_name}
      repo_params[:short_description] = short_description unless short_description.nil?
      repo_params[:description] = description unless description.nil?
      repo_params[:access_type] = access_type unless access_type.nil?
      repo_params[:github_host] = github_host unless github_host.nil?
      repo_params[:github_repo_id] = github_repo_id unless github_repo_id.nil?
      repo_params[:active_build] = active_build unless active_build.nil?
      repo_params[:updated_at] = Time.now
      if is_automated_build
        repo_params[:push_key_id] = repo_name
        repo_params[:push_key_password] = Random.new_seed
        repo_params[:watch_center_id] = watch_center_id unless watch_center_id.nil?
      end

      org = Organization.find name: org_name
      repo = org.add_repository repo_params

      user = nil
      if user_name.nil?
        user = GetOwnerOfOrganization.run org_name: org_name
      else
        user = GetUser.run user_name: user_name if IsMemberOfOrganization.run org_name: org_name, user_name: user_name
      end
      return nil if user.nil?

      repo.add_user user

      if is_automated_build
        build_tags.each do |build_tag|
          repo.add_build_tag build_tag
        end

        gh_client = D2HUB::create_github_client_by_username github_host: repo[:github_host],
                                                            user_name: user_name
        unless gh_client.nil?
          build_tags.each do |build_tag|
            begin
              response = gh_client.contents(github_repo_id, path: "#{build_tag['dockerfile_location']}/README.md", ref: "#{build_tag['git_branch_name']}")
              unless response.content.nil?
                repo.description = Base64.decode64(response.content)
                break
              end
            rescue
            end
          end
          hooks = gh_client.hooks(github_repo_id).select do |hook|
            hook.config.url == ENV['GITHUB_WEBHOOK_URL']
          end

          if hooks.empty?
            hook = gh_client.create_hook(
                github_repo_id,
                'web',
                {
                  url: ENV['GITHUB_WEBHOOK_URL'],
                  content_type: 'json'
                },
                {
                  events: ['push'],
                  active: true
                })
            repo.github_hook_id = hook[:id]
          else
            repo.github_hook_id = hooks[0][:id]
          end
          repo.save
        end
      end

      DB[:collaborators].where(user_id: user[:id], repository_id: repo[:id]).update(role: 'owner')
      Repository[repo[:id]]
    end
  end
end