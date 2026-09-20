# frozen_string_literal: true

require "json"
require "net/http"
require "securerandom"
require "uri"

class PowerShellProObfuscator
  # Stdlib HTTP helper. Multipart for API form posts.
  module Http
    class << self
      def post_multipart(url, fields, user_agent:)
        boundary = "----PELock#{SecureRandom.hex(16)}"
        body = build_multipart(fields, boundary)
        request(url, body, user_agent, "multipart/form-data; boundary=#{boundary}")
      end

      def parse_json(body)
        return nil if body.nil? || body.to_s.empty?

        JSON.parse(body)
      rescue JSON::ParserError
        nil
      end

      def request(url, body, user_agent, content_type)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 30
        http.read_timeout = 180
        req = Net::HTTP::Post.new(uri.request_uri)
        req["User-Agent"] = user_agent
        req["Content-Type"] = content_type
        req.body = body
        http.request(req).body
      rescue StandardError
        nil
      end

      def build_multipart(fields, boundary)
        body = String.new(encoding: Encoding::ASCII_8BIT)
        fields.each do |name, value|
          next if value.nil?

          body << "--#{boundary}\r\n"
          body << "Content-Disposition: form-data; name=\"#{name}\"\r\n\r\n"
          body << value.to_s.dup.force_encoding(Encoding::UTF_8).b
          body << "\r\n"
        end
        body << "--#{boundary}--\r\n"
        body
      end
    end
  end
end
