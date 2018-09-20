require_relative '../base'
require_relative '../model'

module D2HUB
  class Transaction
    def self.run(params)
      new.action params
    rescue Exception => e
      STDERR.puts e
      nil
    end

    def action(params)
      DB.transaction(savepoint: true) { run params }
    end
  end
end