Dir[File.join(File.dirname(__FILE__), 'build', '*.rb')].each do |file|
  require_relative File.join('build', File.basename(file, '.rb'))
end