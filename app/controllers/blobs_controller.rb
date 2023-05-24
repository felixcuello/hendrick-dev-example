# frozen_string_literal: true

class BlobsController < ApplicationController
  before_action :parse_json!, only: [:create]

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: Rails.configuration.file_api.basic_auth_username, password: Rails.configuration.file_api.basic_auth_password

  # POST /blobs/create
  def create
    json = BlobsSvc::Create.file(json: @json)

    render json:, status: :created # http://www.railsstatuscodes.com/
  end

  # Parses the JSON and generates an exception if it fails
  def parse_json!
    @json = params['blob'].as_json
  rescue StandardError
    render json: {error: 'unprocessible_entry'}, status: :unprocessable_entity # http://www.railsstatuscodes.com/
  end
end
