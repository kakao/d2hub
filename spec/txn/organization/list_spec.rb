require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe GetOrganizations do
    subject { GetOrganizations }

    let(:user_name) { 'test_user' }

    before do
      CreateUser.run user_name: user_name
      (1..100).each do |num|
        CreateOrganization.run user_name: user_name, org_name: "org_#{num}"
      end
    end

    it 'should get organization list' do
      orgs = GetOrganizations.run user_name: user_name
      expect(orgs.length).to eq 101
    end
  end
end