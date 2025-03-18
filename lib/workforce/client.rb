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
        log_request('create comment', payload[:messageId])
        url = URI("#{config.ticket_endpoint}/#{payload[:extRefId]}/ticket-messages")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_post_request(url, config, payload.slice(:messageId, :message).to_json)
        response = https.request(request)
        log_response('create comment', payload[:messageId], request, response)
      end

      def update_comment(config, payload)
        log_request('update comment', payload[:messageId])
        url = URI("#{config.ticket_endpoint}/ticket-messages/#{payload[:messageId]}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_patch_request(url, config, payload.slice(:message).to_json)
        response = https.request(request)
        log_response('update comment', payload[:messageId], request, response)
      end

      def destroy_comment(config, payload)
        log_request('destroy comment', payload[:messageId])
        url = URI("#{config.ticket_endpoint}/ticket-messages/#{payload[:messageId]}")
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = build_destroy_request(url, config, '')
        response = https.request(request)
        log_response('destroy comment', payload[:messageId], request, response)
      end

      private

      def build_post_request(url, config, payload)
        request = Net::HTTP::Post.new(url)
        request['X-API-Key'] = config.default_api_key
        request['X-Client'] = url.host.split('.').first
        request.content_type = 'application/json'
        request.body = payload
        request
      end

      def build_patch_request(url, config, payload)
        request = Net::HTTP::Patch.new(url)
        request['X-API-Key'] = config.default_api_key
        request['X-Client'] = url.host.split('.').first
        request.content_type = 'application/merge-patch+json'
        request.body = payload
        request
      end

      def build_destroy_request(url, config, payload)
        request = Net::HTTP::Delete.new(url)
        request['X-API-Key'] = config.default_api_key
        request['X-Client'] = url.host.split('.').first
        request.content_type = 'application/json'
        request.body = payload if payload.present?
        request
      end

      def log_request(action, id)
        Workforce.logger.info("Requesting to #{action} for #{id}")
      end

      def log_response(action, id, request, response)
        Workforce.logger.info("Got #{response.try(:code)} response for #{action} request for #{id}")
        return if ["200", "201"].include?(response.code.to_s)

        Workforce.logger.error "request-body: #{request.body.inspect}"
        Workforce.logger.error "response-body: #{response.body.inspect}"
        Workforce.logger.error "response-message: #{response.message.inspect}"
      end
    end
  end
end
