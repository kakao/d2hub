require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe GetTagsOfRepository do
    subject { GetTagsOfRepository }

    it 'should get tags of repository' do
      GetTagsOfRepository.run org_name: 'fpgeek',
                              repo_name: 'sinatra'
    end
  end
end