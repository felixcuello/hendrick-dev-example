# frozen_string_literal: true

module Support
  module ResponseHelpers
    def response_json
      body = response.body
      body.empty? ? nil : JSON.parse(body)
    end

    def response_error
      response_errors.first
    end

    def response_errors
      response_json.fetch("errors")
    end

    def response_data
      response_json.fetch("data")
    end
  end
end
