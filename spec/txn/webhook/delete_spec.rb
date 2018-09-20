require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/webhook'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe DeleteWebhook do
    subject { DeleteWebhook }

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
    end

    it 'should delete a webhook' do

      new_webhook = CreateWebhook.run org_name: params[:org_name],
                                      repo_name: params[:repo_name],
                                      webhook_url: webhook_url,
                                      webhook_auth: webhook_auth
      expect(new_webhook).to be_truthy

      webhook1 = GetWebhook.run webhook_id: new_webhook[:id]
      expect(webhook1).to be_truthy

      DeleteWebhook.run webhook_id: new_webhook[:id]

      webhook2 = GetWebhook.run webhook_id: new_webhook[:id]
      expect(webhook2).to be_nil

    end
  end
end