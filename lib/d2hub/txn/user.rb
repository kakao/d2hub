Dir[File.join(File.dirname(__FILE__), 'user', '*.rb')].each do |file|
  require_relative File.join('user', File.basename(file, '.rb'))
end