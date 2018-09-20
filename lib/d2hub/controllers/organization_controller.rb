require 'sinatra/base'
require 'haml'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class OrganizationController < D2hubBase
    register ControllerRegister

    get '/organization/add' do
      @error = params[:error]
      haml :add_org
    end

    get '/orgs/:org_name/edit/member' do |org_name|
      halt_not_authorized unless member_of_organization? org_name
      @members = GetMembersOfOrganization.run org_name: org_name
      @org_name = org_name
      @error = params[:error]
      haml :layout_edit do
        haml :edit_org_member
      end
    end

    get '/orgs/:org_name/edit/profile' do |org_name|
      halt_not_authorized unless member_of_organization? org_name
      @org = GetOrganization.run org_name: org_name
      @org_name = org_name
      haml :layout_edit do
        haml :edit_org_profile
      end
    end

    post '/orgs' do
      redirect to("#{URI(back).path}?error=dismiss_required_fields") if params['org_name'] == ''
      redirect to("#{URI(back).path}?error=already_exists") if user_id != params['org_name'] and AuthController.exist? params['org_name']
      org_name_length = params['org_name'].length
      redirect to("#{URI(back).path}?error=invalid_org_name") if (/^[a-z0-9_]+$/ =~ params['org_name']).nil? or (org_name_length < 4) or (30 < org_name_length)
      result = CreateOrganization.run user_name: user_id,
                                      org_name: params['org_name'],
                                      description: params['description']
      redirect to("#{URI(back).path}?error=already_exists") if result.nil?
      redirect "/users/#{user_id}"
    end

    put '/orgs/:org_name' do |org_name|
      halt 401 unless member_of_organization? org_name
      EditOrganization.run org_name: org_name, description: params['description']
      redirect "orgs/#{org_name}/repos"
    end

    delete '/orgs/:org_name' do |org_name|
      halt 401 unless member_of_organization? org_name
      halt 400 if primary_organization? org_name
      DeleteOrganization.run org_name: org_name
      status 200
    end

    post '/orgs/:org_name/members' do |org_name|
      halt 401 unless member_of_organization? org_name
      unless ExistUser.run user_name: params[:user_name]
        if AuthController.exist? params[:user_name]
          CreateUser.run user_name: params[:user_name]
        else
          redirect to("#{URI(back).path}?error=not_exists")
        end
      end

      result = AddMemberToOrganization.run org_name: org_name,
                                           user_name: params[:user_name]
      redirect to("#{URI(back).path}?error=already_exists") if result.nil?
      redirect URI(back).path
    end

    delete '/orgs/:org_name/members/:user_name' do |org_name, user_name|
      halt 401 unless member_of_organization? org_name
      redirect to("#{URI(back).path}?error=delete_failed") unless ExistUser.run user_name: params[:user_name]
      RemoveMemberFromOrganization.run org_name: org_name,
                                       user_name: user_name
      redirect URI(back).path
    end

  end
end