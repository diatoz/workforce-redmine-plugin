module Workforce
  class Logger
    @@logger = ::Logger.new(Rails.root.join('log/workforce.log'))

    def self.log(message)
      @@logger.info message
    end
  end
end
