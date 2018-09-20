require 'sinatra/base'
require 'haml'
require_relative '../txn'
require_relative 'register'

module D2HUB
  class SearchRepoController < D2hubBase
    register ControllerRegister

    get '/search/repos' do
      # @top_contributors = GetTopContributors.run count: 5
      @recently_repos = GetAllRepositories.run count: 10
      @popular_repos = GetPopularRepositories.run count: 10
      @search_repos = SearchRepositories.run query: params[:q]
      haml :search_repo
    end

  end
end