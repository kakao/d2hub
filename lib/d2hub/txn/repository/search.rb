require_relative '../transaction'

module D2HUB
  class SearchRepositories < Transaction
    def self.run(query: nil)
      return nil if query.nil?

      repos = DB['SELECT r.*, o.name AS organization_name FROM repositories r, organizations o WHERE r.organization_id = o.id AND r.access_type = "public" AND (r.name LIKE ? or o.name LIKE ?)', "%#{query}%", "%#{query}%"].all
      repo_ids = repos.map {|repo| repo[:id]}
      start_count_map = DB[:stars].group_and_count(:repository_id).where(repository_id: repo_ids).to_hash(:repository_id, :count)
      repos.map do |repo|
        repo[:star_count] = start_count_map[repo[:id]] || 0
        repo
      end.sort do |repo1, repo2|
        repo2[:star_count] <=> repo1[:star_count]
      end
    end
  end
end