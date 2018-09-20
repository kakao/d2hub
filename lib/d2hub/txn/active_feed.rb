Dir[File.join(File.dirname(__FILE__), 'active_feed', '*.rb')].each do |file|
  require_relative File.join('active_feed', File.basename(file, '.rb'))
end