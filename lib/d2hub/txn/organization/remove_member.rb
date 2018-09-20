require_relative '../transaction'

module D2HUB
  class RemoveMemberFromOrganization < Transaction
    def run(org_name: nil, user_name: nil)
      org = Organization.find name: org_name
      user = User.find name: user_name
      org.remove_user user
    end
  end
end