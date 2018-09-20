require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/organization'

module D2HUB
  describe GetOwnerOfOrganization do
    subject { GetOwnerOfOrganization }

    let(:user_name) { 'test_user' }
    let(:org_name) { 'test_org' }

    before do
      CreateUser.run user_name: user_name
      CreateOrganization.run user_name: user_name,
                             org_name: org_name
    end

    it 'should get owner of organization' do
      owner = GetOwnerOfOrganization.run org_name: org_name
      expect(owner).to be_truthy
      expect(owner[:name]).to eq user_name
    end
  end
end