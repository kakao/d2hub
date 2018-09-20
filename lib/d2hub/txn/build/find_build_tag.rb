require_relative '../transaction'
require_relative '../repository'

module D2HUB
  class FindBuildTags < Transaction
    def run(repo: nil,
            git_type: nil,
            git_branch_name: nil)
      STDERR.puts "[FindBuildTags] repo: #{repo}"
      STDERR.puts "[FindBuildTags] repo.build_tags: #{repo.build_tags}"
      repo.build_tags.map do |build_tag|
        STDERR.puts "[FindBuildTags] build_tag.git_type: #{build_tag.git_type}"
        STDERR.puts "[FindBuildTags] build_tag.git_branch_name: #{build_tag.git_branch_name}"
        STDERR.puts "[FindBuildTags] build_tag.use_regex: #{build_tag.use_regex}"
        if build_tag.git_type == git_type
          if build_tag.use_regex
            if Regexp.new(build_tag.git_branch_name) =~ git_branch_name
              build_tag.git_branch_name = git_branch_name
              build_tag.docker_tag_name = git_branch_name
              build_tag
            else
              nil
            end
          else
            if build_tag.git_branch_name == git_branch_name
              build_tag
            else
              nil
            end
          end
        end
      end.compact
    end
  end
end