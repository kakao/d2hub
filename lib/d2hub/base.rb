require 'sinatra/base'

module D2HUB
  @github_hosts = {
      'github' => {
          host: 'github.com',
          client_id: ENV['KAKAO_GITHUB_CLIENT_ID'],
          client_secret: ENV['KAKAO_GITHUB_CLIENT_SECRET_ID'],
          name: 'GitHub',
          image: '/img/github_logo.png'
      }
  }

  def self.github_info(github_host)
    return @github_hosts[github_host]
  end

  def self.github_hosts
    @github_hosts
  end


  def self.github_endpoint(github_host)
    #public github
    return "https://api.#{github_host}/" if github_host == 'github.com'

    #github enterprise
    return "https://#{github_host}/api/v3"
  end

  def self.valid_org_name(org_name)
    org_name.gsub(/\./, '_')
  end

  def self.admin_organization?(org_name)
    org_name == 'd2hub'
  end

  def self.full_repo_name(org_name, repo_name)
    if self.admin_organization? org_name
      repo_name
    else
      "#{org_name}/#{repo_name}"
    end
  end

  def self.use_watchcenter
    ENV['USE_WATCHCENTER']
  end

  def self.use_antivirus
    ENV['USE_ANTIVIRUS']
  end

  class D2hubBase < Sinatra::Base
    configure do
      set helptext: ENV['HELP_TEXT']
      set helpurl: ENV['HELP_URL']
      set github_infos: D2HUB::github_hosts
      set antivirus_link: ENV['ANTIVIRUS_LINK'] || 'http://localhost'
      set antivirus_name: ENV['ANTIVIRUS_NAME'] || '문의'
    end
  end

end