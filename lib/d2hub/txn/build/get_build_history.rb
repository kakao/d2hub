require_relative '../transaction'

module D2HUB
  class GetBuildHistory < Transaction
    def run(id: nil)
      BuildHistory.first(id: id)
    end
  end
end