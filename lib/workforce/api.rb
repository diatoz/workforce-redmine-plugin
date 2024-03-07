module Workforce
  class Api
    def self.logger
      Workforce.logger
    end

    def self.notify(request_url, token, message)
      url = URI(request_url)
      https = Net::HTTP.new(url.host, url.port)
      # https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request['Authorization'] = "Bearer #{token}"
      request['Protocol'] = "oidc"
      request.content_type = 'application/json'
      request.body = message
      response = https.request(request)
    rescue => e
      logger.error e.message
    end
  end
end
