require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/user'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetTopContributors do
    subject { GetTopContributors }

    before do
      (1..10).each do |num|
        user_name = "user_#{num}"
        CreateUser.run user_name: user_name
      end

      (2..10).each_with_index do |item, index|
        (item..10).each do |num|
          CreateRepository.run org_name: "user_#{index + 1}",
                               repo_name: "repo_#{num}"
        end
      end
    end

    it 'should get popular repositories' do
      users = GetTopContributors.run count: 5
      expect(users.length).to eq 5
    end
  end
end