require 'sinatra/base'
require 'time'
require 'digest/md5'
require_relative '../txn/user'
require_relative '../txn/organization'
require_relative '../txn/repository'
require 'github/markdown'

module D2HUB
  module ControllerHelper

    def registry_url
      'd2hub.com'
    end

    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def user_img_url(user_name, size)
      email = "#{user_name.gsub(/_/, '.')}@d2hub.com"
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}&d=mm"
    end

    def halt_not_authorized
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized. Please visit #{base_url}/help\n"
    end

    ### Deprecated
    # def protected?
    #   login? or authorized?
    # end
    #
    # def protected!
    #   halt_not_authorized unless protected?
    # end

    def session_redirect!(redirect_uri='/')
      redirect redirect_uri unless login?
    end

    def login_user?(user_name)
      user_id == user_name
    end

    def login_user!(user_name)
      halt_not_authorized unless login_user? user_name
    end

    def login_user_redirect!(user_name)
      redirect '/' unless login_user? user_name
    end

    def valid_push_key?(org_name, repo_name)
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and IsValidPushKeyOfRepository.run org_name: org_name,
                                                                                                repo_name: repo_name,
                                                                                                push_key_id: @auth.credentials[0],
                                                                                                push_key_password: @auth.credentials[1]
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and AuthController.check(@auth.credentials[0], @auth.credentials[1], request.ip)
    end

    def authorized!
      halt_not_authorized unless authorized?
    end

    def has_pull_auth?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      if @auth.provided? and @auth.basic? and @auth.credentials
        cred = @auth.credentials
        return ((ENV['PULL_AUTH_USERNAME'] == cred[0]) and (ENV['PULL_AUTH_PASSWORD'] == cred[1]))
      end
      false
    end

    def basic_auth_user_name
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.credentials[0]
    end

    def login?
      !!session[:user_id]
    end

    def user_id
      if login?
        session[:user_id]
      elsif authorized?
        @auth.credentials[0]
      end
    end

    def admin?
      login? and eval(ENV['ADMINS']).include?(user_id)
    end

    def admin!
      return if admin?
      halt_not_authorized
    end

    def owner_of_organization?(org_name)
      owner = GetOwnerOfOrganization.run org_name: org_name
      owner[:name] == user_id
    end

    def member_of_organization?(org_name)
      IsMemberOfOrganization.run org_name: org_name,
                                 user_name: user_id
    end

    def collaborator_of_repository?(org_name, repo_name)
      IsCollaboratorOfRepository.run org_name: org_name,
                                     repo_name: repo_name,
                                     user_name: user_id
    end

    def has_authority_of_repository?(org_name, repo_name)
      admin? or member_of_organization?(org_name) or collaborator_of_repository?(org_name, repo_name)
    end

    def primary_organization?(org_name)
      owner_of_organization?(org_name) and IsMainTypeOrganization.run(org_name: org_name)
    end

    def valid_repository!(org_name, repo_name)
      halt 404 unless ExistOrganization.run org_name: org_name
      halt 404 unless ExistRepository.run org_name: org_name,
                                          repo_name: repo_name
    end

    def valid_organization!(org_name)
      halt 404 unless ExistOrganization.run org_name: org_name
    end

    def valid_user!(user_name)
      halt 404 unless ExistUser.run user_name: user_name
    end

    def admin_organization?(org_name)
      D2HUB::admin_organization? org_name
    end

    def full_repo_name(org_name, repo_name)
      D2HUB::full_repo_name org_name, repo_name
    end

    def age_ko(date = Time.now)
      return '' if date.nil?
      d = Time.now.to_i - date.to_i
      시간 = 3600
      일  = 24 * 시간
      주  = 7 * 일
      월  = 30 * 일
      case d
        when 0..59
          '방금'
        when 60..(시간-1)
          "#{d/60}분전"
        when 시간..(일-1)
          "#{d/시간}시간전"
        when 일..(주-1)
          "#{d/일}일전"
        when 주..(월-1)
          "#{d/주}주전"
        when 월..(7*월-1)
          "#{d/월}개월전"
        else
          if date.year == Time.now.year
            date.strftime "%-m월 %-d일"
          else
            date.strftime "%Y-%m-%d"
          end
      end
    end

    def parse_markdown(markdown_contents)
      GitHub::Markdown.render markdown_contents
    end
  end
end