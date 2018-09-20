require 'net/http'
require 'net/https'
require 'uri'
require 'xmlrpc/client'
require 'rest-client'
require 'json'
require 'logger'
require_relative 'custom_auth'

module D2HUB
  class AuthController
    @@logger = Logger.new(STDOUT)
    @@custom_auth_option = 'custom'

    def self.check(user_id, password, ip)
      # return true
      # WORKAROUND: incorrectly success to bind when password is empty
      if ENV['AUTH_TYPE'] == @@custom_auth_option or ENV['AUTH_TYPE'].nil?
        unless user_id.empty? or password.empty?
          res = D2HUB::checkCustom(user_id, password, ip)
          return (res == "true" and self.exist? user_id)
        end
      elsif ENV['AUTH_TYPE'] == 'keystone'
        return (self.auth_by_keystone(user_id, password))
      end
      false
    end

    def self.auth_by_keystone(user_id, password)
      unless user_id.empty? or password.empty?
        payload = {
            auth: {
                identity: {
                    methods: [ "password" ],
                    password: {
                        user: {
                            name: user_id,
                            domain: { name: "Default" },
                            password: password
                        }
                    }
                }
            }
        }
        headers = {:content_type => 'application/json'}

        begin
          response = RestClient.post("#{ENV['AUTH_URL']}/auth/tokens",
                                     payload.to_json,
                                     headers)
        rescue Exception => e
          @@logger.error e.backtrace.join("\n")
          @@logger.error("user : #{user_id} loggin error #{e.response}")
          return false
        end
        return response.code == 201
      end
      false
    end

    def self.exist?(user_id)
      if ENV['AUTH_TYPE'] == @@custom_auth_option or ENV['AUTH_TYPE'].nil?
        # return (self.regular_employee?(user_id) or self.authorized_users?(user_id))
        return D2HUB::custom_exist(user_id)
      elsif ENV['AUTH_TYPE'] == 'keystone'
        return self.exist_in_keystone?(user_id)
      end
      false
    end

    def self.exist_in_keystone?(user_id)
      headers = {:content_type => 'application/json',
                :X_Subject_Token => ENV['KEYSTONE_ADMIN_TOKEN'],
                :X_Auth_Token => ENV['KEYSTONE_ADMIN_TOKEN']}
      begin
        response = RestClient.get("#{ENV['AUTH_URL']}/users",
                                   headers)
        total_user_list = JSON.parse(response.body)
        total_user_list['users'].each do |user|
          if user['name'] == user_id
            return true
          end
        end
      rescue Exception => e
        @@logger.error("user : #{user_id} exist check error #{e.response}")
        @@logger.error e.backtrace.join("\n")
      ensure
        return false
      end
    end

  end
end