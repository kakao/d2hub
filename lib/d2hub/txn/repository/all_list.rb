require_relative '../transaction'

module D2HUB
  class GetAllRepositories < Transaction
    def run(count: nil)
      if count.nil?
        repos = Repository.eager(:organization).order(:updated_at, :created_at).reverse.all
        repos.select do |repo|
          not (repo.organization.nil?)
        end
      else
        repos = Repository.eager(:organization).order(:updated_at, :created_at).reverse.limit(count).all
        repos.select do |repo|
          not (repo.organization.nil?)
        end
      end

    end
  end
end