module Workforce
  class Client
    class << self
      def create_ticket(config, payload)
        execute_request(
          method: :post,
          endpoint: config.ticket_endpoint,
          api_key: config.ticket_api_key,
          payload: payload,
          reference_id: payload[:extRefId],
          user_id: payload[:createdById],
          action_name: 'create ticket'
        )
      end

      def update_ticket(config, payload)
        execute_request(
          method: :patch,
          endpoint: "#{config.ticket_endpoint}/#{payload[:extRefId]}",
          api_key: config.ticket_api_key,
          payload: payload,
          reference_id: payload[:extRefId],
          user_id: payload[:lastModifiedId],
          action_name: 'update ticket'
        )
      end

      def create_comment(config, payload)
        execute_request(
          method: :post,
          endpoint: "#{config.ticket_endpoint}/#{payload[:extRefId]}/ticket-messages",
          api_key: config.ticket_api_key,
          payload: payload.slice(:messageId, :message),
          reference_id: payload[:messageId],
          user_id: payload[:createdById],
          action_name: 'create comment'
        )
      end

      def update_comment(config, payload)
        execute_request(
          method: :patch,
          endpoint: "#{config.ticket_endpoint}/ticket-messages/#{payload[:messageId]}",
          api_key: config.ticket_api_key,
          payload: { message: payload[:message] },
          reference_id: payload[:messageId],
          user_id: payload[:lastModifiedId],
          action_name: 'update comment'
        )
      end

      def destroy_comment(config, payload)
        execute_request(
          method: :delete,
          endpoint: "#{config.ticket_endpoint}/ticket-messages/#{payload[:messageId]}",
          api_key: config.ticket_api_key,
          payload: nil,
          reference_id: payload[:messageId],
          user_id: payload[:deletedById],
          action_name: 'destroy comment'
        )
      end

      def create_user(config, payload)
        execute_request(
          method: :post,
          endpoint: config.user_endpoint,
          api_key: config.user_api_key,
          payload: payload,
          reference_id: payload[:externalReferenceId],
          action_name: 'create user'
        )
      end

      def update_user(config, payload)
        execute_request(
          method: :patch,
          endpoint: "#{config.user_endpoint}/#{payload[:externalReferenceId]}",
          api_key: config.user_api_key,
          payload: payload,
          reference_id: payload[:externalReferenceId],
          action_name: 'update user'
        )
      end

      def create_group(config, payload)
        execute_request(
          method: :post,
          endpoint: config.group_endpoint,
          api_key: config.group_api_key,
          payload: payload,
          reference_id: payload[:extRefId],
          action_name: 'create group'
        )
      end

      def update_group(config, payload)
        execute_request(
          method: :patch,
          endpoint: "#{config.group_endpoint}/#{payload[:extRefId]}",
          api_key: config.group_api_key,
          payload: payload,
          reference_id: payload[:extRefId],
          action_name: 'update group'
        )
      end

      private

      def execute_request(options = {})
        method = options[:method]
        endpoint = options[:endpoint]
        api_key = options[:api_key]
        payload = options[:payload]
        reference_id = options[:reference_id]
        action_name = options[:action_name]
        include_client = options.fetch(:include_client, true)
        user_id = options.fetch(:user_id, nil)

        log_request(action_name, reference_id)

        url = URI(endpoint)
        client_name = include_client ? url.host.split('.').first : nil
        response = make_http_request(method, url, api_key, payload, client_name, user_id)

        log_response(action_name, reference_id, payload, response)
        response
      end

      def make_http_request(method, url, api_key, payload, client_name, user_id)
        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        request = create_request_object(method, url)
        set_headers(request, api_key, client_name, user_id)
        set_body(request, payload) if payload_required?(method, payload)
        https.request(request)
      end

      def create_request_object(method, url)
        case method
        when :post
          Net::HTTP::Post.new(url)
        when :patch
          Net::HTTP::Patch.new(url)
        when :delete
          Net::HTTP::Delete.new(url)
        else
          raise ArgumentError, "Unsupported HTTP method: #{method}"
        end
      end

      def set_headers(request, api_key, client_name, user_id)
        request['X-API-Key'] = api_key
        request['X-Client'] = client_name if client_name
        request['X-User-Id'] = user_id if user_id
        request.content_type = determine_content_type(request)
      end

      def determine_content_type(request)
        case request
        when Net::HTTP::Patch
          'application/merge-patch+json'
        else
          'application/json'
        end
      end

      def set_body(request, payload)
        request.body = payload.is_a?(String) ? payload : payload.to_json
      end

      def payload_required?(method, payload)
        [:post, :patch].include?(method) || (method == :delete && payload&.present?)
      end

      def log_request(action, id)
        Workforce.logger.info("Requesting to #{action} for #{id}")
      end

      def log_response(action, id, request_payload, response)
        Workforce.logger.info("Got #{response&.code} response for #{action} request for #{id}")
        if successful_response?(response)
          # log_details(request_payload, response)
          return true
        else
          log_error_details(request_payload, response)
        end
        return true
      end

      def successful_response?(response)
        %w[200 201 204].include?(response&.code)
      end

      def log_error_details(request_payload, response)
        Workforce.logger.error "request-body: #{request_payload.inspect}"
        Workforce.logger.error "response-body: #{response&.body.inspect}"
        Workforce.logger.error "response-message: #{response&.message.inspect}"
      end

      def log_details(request_payload, response)
        Workforce.logger.info "request-body: #{request_payload.inspect}"
        Workforce.logger.info "response-body: #{response&.body.inspect}"
        Workforce.logger.info "response-message: #{response&.message.inspect}"
      end
    end
  end
end
