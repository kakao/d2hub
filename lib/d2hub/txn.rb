require_relative 'txn/user'
require_relative 'txn/repository'
require_relative 'txn/organization'
require_relative 'txn/active_feed'
require_relative 'txn/comment'
require_relative 'txn/build'
require_relative 'txn/webhook'
require_relative 'txn/marathon_deploy'
require_relative 'txn/kubernetes_deploy'
require_relative 'txn/drscan'
require 'octokit'

module D2HUB
  def self.get_github_access_token(github_host: nil, user_name: nil)
    return nil if github_host.nil?
    return nil if user_name.nil?

    user = GetUser.run user_name: user_name
    return nil if user.nil?

    D2HUB::github_hosts.each do |key, value|
      if github_host == value[:host]
        if key.include? 'kakaocorp'
          return user[:kakaocorp_github_access_token]
        else
          return user[:github_access_token]
        end
      end
    end
  end

  def self.create_github_client_by_username(github_host: nil, user_name: nil)
    github_access_token = get_github_access_token github_host: github_host,
                                           user_name: user_name
    return nil if github_access_token.nil?

    self.create_github_client_by_token github_host: github_host,
                                       github_access_token: github_access_token
  end

  def self.create_github_client_by_token(github_host: nil, github_access_token: nil)
    return nil if github_host.nil?
    return nil if github_access_token.nil?
    Octokit::Client.new access_token: github_access_token,
                        api_endpoint: github_endpoint(github_host),
                        auto_paginate: true
  end

  def self.parse_git_type_and_branch_name(gh_ref: nil)
    git_type = nil
    git_branch_name = nil
    branchMatch = /^refs\/heads\/(.+)/.match(gh_ref)
    unless branchMatch.nil?
      git_type = 'Branch'
      git_branch_name = branchMatch[1]
    end
    tagMatch = /^refs\/tags\/(.+)/.match(gh_ref)
    unless tagMatch.nil?
      git_type = 'Tag'
      git_branch_name = tagMatch[1]
    end
    return git_type, git_branch_name
  end
end