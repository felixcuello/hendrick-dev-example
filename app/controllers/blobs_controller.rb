# frozen_string_literal: true

# This is the blobs controller :-)
class BlobsController < ApplicationController
  before_action :parse_json!, only: [:create]
  before_action :get_file_id, only: [:show]

  # GET /blobs
  def index
    json = BlobsSvc::Directory.list.as_json

    render json:, status: :ok
  end

  # GET /blobs/:id
  def show
    file = BlobsSvc::Directory.get_server_file(id: @id)

    send_data file[:content], filename: file[:file_name], type: request.content_type
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

  def get_file_id
    @id = params.fetch('id', 0).to_s
  end
end
