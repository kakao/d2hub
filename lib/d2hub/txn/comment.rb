Dir[File.join(File.dirname(__FILE__), 'comment', '*.rb')].each do |file|
  require_relative File.join('comment', File.basename(file, '.rb'))
end