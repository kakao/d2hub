require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/webhook'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetWebhooks do
    subject { GetWebhooks }

    let(:params) do
      {
          org_name: 'test_user',
          repo_name: 'test_repo',
          description: 'test repository'
      }
    end
    let(:user_name) { 'test_user' }
    let(:webhook_url) { 'http://localhost:8999' }
    let(:webhook_auth) { 'testuser:testpass' }

    before do
      CreateUser.run user_name: user_name
      CreateRepository.run params
      (1..10).each do |num|
        CreateWebhook.run org_name: params[:org_name],
                          repo_name: params[:repo_name],
                          webhook_url: webhook_url,
                          webhook_auth: webhook_auth
      end

    end

    it 'should get webhooks of a repository' do
      webhooks = GetWebhooks.run org_name: params[:org_name],
                                 repo_name: params[:repo_name]
      expect(webhooks.length).to eq 10
    end
  end
end