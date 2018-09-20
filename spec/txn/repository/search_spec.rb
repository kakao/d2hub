require_relative '../spec_helper'
require_relative '../../../lib/d2hub/txn/repository'

module D2HUB
  describe SearchRepositories do
    subject { SearchRepositories }

    it 'should search repositories' do
      result = SearchRepositories.run query: 'fp'
      puts result
    end
  end
end