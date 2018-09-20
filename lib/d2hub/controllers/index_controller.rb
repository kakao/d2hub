require 'sinatra/base'
require 'sinatra/session'
require 'haml'
require_relative 'register'
require_relative 'auth_controller'

module D2HUB
  class IndexController < D2hubBase
    register ControllerRegister

    get '/' do
      if login?
        CreateUser.run user_name: user_id unless ExistUser.run user_name: user_id
        redirect '/search/repos'
      else
        haml :login
      end
    end

    post '/login' do
      if AuthController.check(params[:username], params[:password], request.ip)
        session_start!
        session[:user_id] = params[:username]
      else
        session_end!
      end

      redirect '/'
    end

    get '/logout' do
      session_end!
      redirect '/', 303
    end

    put '/change_language' do
      I18n.locale == :en ? (I18n.locale = :ko) : (I18n.locale = :en)
      status 200
    end
  end
end