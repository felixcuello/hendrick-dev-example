# frozen_string_literal: true

RSpec.shared_context(:with_basic_authorization, shared_context: :metadata) do
  let(:credentials) {
    [
      Rails.configuration.file_api.basic_auth_username,
      Rails.configuration.file_api.basic_auth_password
    ]
  }

  def basic_authorization
    ActionController::HttpAuthentication::Basic.encode_credentials(*credentials)
  end
end
