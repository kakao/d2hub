Dir[File.join(File.dirname(__FILE__), 'marathon_deploy', '*.rb')].each do |file|
  require_relative File.join('marathon_deploy', File.basename(file, '.rb'))
end