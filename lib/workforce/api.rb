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
      request['X-Client'] = url.host.split('.').first
      request.content_type = 'application/json'
      request.body = data[:message]
      response = https.request(request)
    end
  end
end
