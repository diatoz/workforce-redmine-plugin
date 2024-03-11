module Workforce
  class Api
    def self.logger
      Workforce.logger
    end

    def self.notify(data)
      url = URI(data[:url] + '/abc/services/helpdesk/api/bot/tickets')
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request['X-API-Key'] = data[:api_key]
      request['Protocol'] = "oidc"
      request['X-Client'] = data[:client]
      request.content_type = 'application/json'
      request.body = data[:message]
      response = https.request(request)
      logger.info "workforce api message sent : #{data[:message]}"
      logger.info "workforce api response #{response.read_body}"
    rescue => e
      logger.error e.message
    end
  end
end
