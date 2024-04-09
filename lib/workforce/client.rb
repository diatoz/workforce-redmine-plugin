module Workforce
  class Client
    class << self
      def create_ticket(config, payload)
        log_request('create ticket', payload[:extRefId])
        url = URI("https://#{config.domain}/abc/services/helpdesk/api/bot/tickets")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_post_request(url, config, payload.to_json)
        response = https.request(request)
        log_response('create ticket', payload[:extRefId], response)
      end

      def update_ticket(config, payload)
        log_request('update ticket', payload[:extRefId])
        url = URI("https://#{config.domain}/abc/services/helpdesk/api/bot/tickets/#{payload[:extRefId]}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_patch_request(url, config, payload.to_json)
        response = https.request(request)
        log_response('update ticket', payload[:extRefId], response)
      end

      def create_comment(config, payload)
        log_request('create comment', payload[:extRefId])
        url = URI("https://#{config.domain}/abc/services/helpdesk/api/bot/tickets/#{payload[:extRefId]}/ticket-messages")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_post_request(url, config, payload[:message])
        response = https.request(request)
        log_response('create comment', payload[:extRefId], response)
      end

      private

      def build_post_request(url, config, payload)
        request = Net::HTTP::Post.new(url)
        request['X-API-Key'] = config.api_key
        request['X-Client'] = url.host.split('.').first
        request.content_type = 'application/json'
        request.body = payload
        request
      end

      def build_patch_request(url, config, payload)
        request = Net::HTTP::Patch.new(url)
        request['X-API-Key'] = config.api_key
        request['X-Client'] = url.host.split('.').first
        request.content_type = 'application/merge-patch+json'
        request.body = payload
        request
      end

      def log_request(action, id)
        Workforce.logger.info("Requsting to #{action} for #{id}")
      end

      def log_response(action, id, response)
        Workforce.logger.info("Got #{response.try(:code)} response for #{action} request for #{id}")
      end
    end
  end
end
