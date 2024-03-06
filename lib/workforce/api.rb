module Workforce
  class Api
    def self.notify(request_url, token, message)
      url = URI(request_url)
      https = Net::HTTP.new(url.host, url.port)
      # https.use_ssl = true
      request = Net::HTTP::Post.new(url)
      request['Authorization'] = "Bearer #{token}"
      request['Protocol'] = "oidc"
      request.content_type = 'application/json'
      request.body = message
      Workforce::Logger.log message
      response = https.request(request)
      Workforce::Logger.log "Response #{response.read_body}"
      raise e
    rescue => e
      Workforce::Logger.log "workforce api failed"
      Workforce::Logger.log e.message
    end
  end
end
