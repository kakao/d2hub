require 'sinatra/session'
require_relative 'helper'

module D2HUB
  module ControllerRegister
    def self.registered(app)
      app.register Sinatra::Session
      app.helpers ControllerHelper

      app.enable :logging
      app.set :root, File.expand_path('../../../../', __FILE__)
      app.set :session_secret, 'super secret'
      app.set :views, app.settings.root + '/views'
      app.set :public_folder, app.settings.root + '/public'
      app.set :haml, escape_html: true
      app.enable :method_override

      app.not_found do
        haml :error
      end

      app.before '/api/orgs/:org_name/repos/:repo_name/*' do |org_name, repo_name, path|
        if path != 'pull/count' and path != 'tags'
          halt 401 unless has_authority_of_repository? org_name, repo_name
        end
      end

      app.before '/orgs/:org_name/repos/:repo_name/*' do |org_name, repo_name, _etc|
        valid_repository!(org_name, repo_name) if request.request_method == 'GET'

        unless has_authority_of_repository? org_name, repo_name
          if request.request_method == 'GET'
            redirect '/'
          else
            halt 401
          end
        end
      end

      app.before '/orgs/:org_name/repos/:repo_name' do |org_name, repo_name|
        if request.request_method == 'GET'
          valid_repository!(org_name, repo_name)
        else
          unless has_authority_of_repository? org_name, repo_name
            if request.request_method == 'GET'
              redirect '/'
            else
              halt 401
            end
          end
        end
      end

      app.before '/orgs/:org_name/repos' do |org_name|
        valid_organization! org_name if request.request_method == 'GET'
      end

      app.before '/orgs/:org_name/*' do |org_name, _etc|
        valid_organization! org_name if request.request_method == 'GET'
      end

      app.before '/users/:user_name' do |user_name|
        valid_user! user_name if request.request_method == 'GET'
      end

      app.before '/users/:user_name/*' do |user_name, _etc|
        valid_user! user_name if request.request_method == 'GET'
      end
    end
  end
end