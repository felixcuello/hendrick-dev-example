# frozen_string_literal: true

# This class checks for authentication only
class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: Rails.configuration.file_api.basic_auth_username, password: Rails.configuration.file_api.basic_auth_password
end
