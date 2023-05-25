# frozen_string_literal: true

# This is the blobs controller :-)
class BlobsController < ApplicationController
  before_action :parse_json!, only: [:create]

  # GET /blobs
  def index
    json = BlobsSvc::Directory.list.as_json

    render json:, status: :ok
  end

  # POST /blobs/create
  def create
    json = BlobsSvc::Create.new(json: @json).create_file

    render json:, status: :created # http://www.railsstatuscodes.com/
  end

  # Parses the JSON and generates an exception if it fails
  def parse_json!
    @json = params['blob'].as_json
  rescue StandardError
    render json: {error: 'unprocessible_entry'}, status: :unprocessable_entity # http://www.railsstatuscodes.com/
  end
end
