class BlobsController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: Rails.configuration.file_api.basic_auth_username, password: Rails.configuration.file_api.basic_auth_password

  # POST /blobs/create
  def create
    json = params["blob"].as_json
    uuid = SecureRandom.uuid
    filename = uuid + ".json"

    if File.write("received_files/" + filename, JSON.pretty_generate(json))
      json["document_id"] = uuid
      json["document_filename"] = filename
      render json: json, status: 201
    else
      render json: {error: "unprocessible_entry"}, status: 422
    end
  end
end
