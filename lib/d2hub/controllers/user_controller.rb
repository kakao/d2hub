require 'sinatra/base'
require 'haml'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class UserController < D2hubBase
    register ControllerRegister

    # user
    get '/users/:user_name' do |user_name|
      @user = GetUser.run user_name: user_name
      @orgs = GetOrganizations.run user_name: user_name
      @repos = GetRecentlyUpdatedRepositories.run user_name: user_name
      @starred_repos = GetStarredRepositories.run user_name: user_name
      @contributed_repos = GetContributedRepositories.run user_name: user_name
      @active_feeds = GetActiveFeeds.run user_name: user_name
      @org_name = D2HUB::valid_org_name user_name
      haml :layout_main do
        haml :index do
          haml :_add_repo_btn
        end
      end
    end

    get '/users/:user_name/starred' do |user_name|
      @user = GetUser.run user_name: user_name
      @orgs = GetOrganizations.run user_name: user_name
      @repos = GetStarredRepositories.run user_name: user_name
      @org_name = D2HUB::valid_org_name user_name
      haml :layout_main do
        haml :starred_repo do
          haml :_add_repo_btn
        end
      end
    end

    post '/users/:user_name' do |user_name|
      user = CreateUser.run user_name: user_name
      user.nil? ? status(400) : status(200)
    end

  end
end