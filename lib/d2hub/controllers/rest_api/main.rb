require 'sinatra/base'
require_relative '../../txn'
require_relative '../register'

module D2HUB
  class RestAPI < D2hubBase
    register ControllerRegister

    head '/api/orgs/:org_name/repos/:repo_name' do |org_name, repo_name|
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      halt 404 if repo.nil?
      status 200
    end

    # docker push authentication => repository 생성
    post '/api/auth/orgs/:org_name/repos/:repo_name/push' do |org_name, repo_name|
      halt 201 if valid_push_key? org_name, repo_name

      authorized!

      user_name = basic_auth_user_name
      CreateUser.run user_name: user_name unless ExistUser.run user_name: user_name

      # halt 406 if user_id != org_name
      create_org_result = CreateOrganization.run user_name: user_name,
                                                 org_name: org_name,
                                                 type: 'sub'

      create_repo_result = nil
      unless ExistRepository.run org_name: org_name, repo_name: repo_name
        create_repo_result = CreateRepository.run user_name: user_name,
                                                  org_name: org_name,
                                                  repo_name: repo_name
      end

      if create_org_result.nil? or create_repo_result.nil?
        is_collaborator = IsCollaboratorOfRepository.run org_name: org_name,
                                                         repo_name: repo_name,
                                                         user_name: user_name
        is_member = IsMemberOfOrganization.run org_name: org_name,
                                               user_name: user_name
        (is_collaborator or is_member) ? (status 201) : (status 401)
      else
        status 201
      end
    end

    # docker pull authentication
    get '/api/auth/orgs/:org_name/repos/:repo_name/pull' do |org_name, repo_name|
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      halt 200 if repo.nil?

      if repo[:access_type] == 'private'
        halt 200 if valid_push_key? org_name, repo_name
        halt 200 if has_pull_auth?

        authorized!
        user_name = basic_auth_user_name

        is_collaborator = IsCollaboratorOfRepository.run org_name: org_name,
                                                         repo_name: repo_name,
                                                         user_name: user_name

        is_member = IsMemberOfOrganization.run org_name: org_name,
                                               user_name: user_name
        if is_collaborator or is_member
          status 200
        else
          status 401
        end
      else
        status 200
      end
    end

    # docker pull count 증가
    put '/api/orgs/:org_name/repos/:repo_name/pull/count' do |org_name, repo_name|
      repo = GetRepository.run org_name: org_name,
                               repo_name: repo_name
      halt 404 if repo.nil?

      IncreaseDownCountOfRepository.run org_name: org_name,
                                        repo_name: repo_name
      status 200
    end

    # docker push event 처리
    post '/api/public/orgs/:org_name/repos/:repo_name/tags/:tag_name/push/event' do |org_name, repo_name, tag_name|
      ret = CallDrScan.run base_url: "#{registry_url}",
                           org_name: org_name,
                           repo_name: repo_name,
                           tag_name: tag_name
      ret ? (status 201) : (status 500)
    end
  end
end