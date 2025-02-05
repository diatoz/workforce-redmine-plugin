module Workforce
  class Client
    class << self
      def create_ticket(config, payload)
        log_request('create ticket', payload[:extRefId])
        url = URI(config.ticket_endpoint)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_post_request(url, config, payload.to_json)
        response = https.request(request)
        log_response('create ticket', payload[:extRefId], request, response)
      end

      def update_ticket(config, payload)
        log_request('update ticket', payload[:extRefId])
        url = URI("#{config.ticket_endpoint}/#{payload[:extRefId]}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_patch_request(url, config, payload.to_json)
        response = https.request(request)
        log_response('update ticket', payload[:extRefId], request, response)
      end

      def create_comment(config, payload)
        log_request('create comment', payload[:extRefId])
        url = URI("#{config.ticket_endpoint}/#{payload[:extRefId]}/ticket-messages")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_post_request(url, config, payload[:message])
        response = https.request(request)
        log_response('create comment', payload[:extRefId], request, response)
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
        Workforce.logger.info("Requesting to #{action} for #{id}")
      end

      def log_response(action, id, request, response)
        Workforce.logger.info("Got #{response.try(:code)} response for #{action} request for #{id}")
        unless response.code.to_s == "200"
          Workforce.logger.error "request-body: #{request.body.inspect}"
          Workforce.logger.error "response-body: #{response.body.inspect}"
          Workforce.logger.error "response-message: #{response.message.inspect}"
        end
      end
    end
  end
end
