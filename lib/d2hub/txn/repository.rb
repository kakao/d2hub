Dir[File.join(File.dirname(__FILE__), 'repository', '*.rb')].each do |file|
  require_relative File.join('repository', File.basename(file, '.rb'))
end
# require_relative 'repository/create'
# require_relative 'repository/get'
# require_relative 'repository/delete'
# require_relative 'repository/add_collaborator'
# require_relative 'repository/get_collaborators'
# require_relative 'repository/remove_collaborator'
# require_relative 'repository/change_collaborator_role'
# require_relative 'repository/check_star'
# require_relative 'repository/uncheck_star'
# require_relative 'repository/get_recently_updated_list'