Dir[File.join(File.dirname(__FILE__), 'organization', '*.rb')].each do |file|
  require_relative File.join('organization', File.basename(file, '.rb'))
end
# require_relative 'organization/create'
# require_relative 'organization/get'
# require_relative 'organization/delete'
# require_relative 'organization/add_member'
# require_relative 'organization/get_members'
# require_relative 'organization/change_member_role'
# require_relative 'organization/remove_member'