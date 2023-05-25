# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blobs', type: :request do
  include_context :with_basic_authorization

  describe 'DELETE /blobs/:id' do
    let(:headers) { { Authorization: basic_authorization, 'Content-Type': Constants::DEFAULT_CONTENT_TYPE, 'X-Request-Id': 'a-correlation-id' } }
    let(:post_headers) { { Authorization: basic_authorization, 'Content-Type': 'application/json', 'X-Request-Id': 'a-correlation-id' } }
    let(:valid_json_params) do
      {
        filename: 'sample.csv',
        file_size: '1324',
        encoding_format: 'UTF-8',
        file: 'ZGVzY3JpcHRpb24sYW1vdW50ClNhbXBsZSBUcmFuc2FjdGlvbiAxLDEyMy4wNQpTYW1wbGUgVHJhbnNhY3Rpb24gMiw1ODQzLjc1ClNhbXBsZSBUcmFuc2FjdGlvbiAzLDkyODMuOTIKU2FtcGxlIFRyYW5zYWN0aW9uIDQsMjkzODQuMjcKU2FtcGxlIFRyYW5zYWN0aW9uIDUsMTIuMzQKU2FtcGxlIFRyYW5zYWN0aW9uIDYsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiA3LDI5MzkuODMKU2FtcGxlIFRyYW5zYWN0aW9uIDgsNDkzLjU0ClNhbXBsZSBUcmFuc2FjdGlvbiA5LDg3NC4yMwpTYW1wbGUgVHJhbnNhY3Rpb24gMTAsMTgyMC4xOApTYW1wbGUgVHJhbnNhY3Rpb24gMTEsMTgyLjIKU2FtcGxlIFRyYW5zYWN0aW9uIDEyLDk4NzYuMjQKU2FtcGxlIFRyYW5zYWN0aW9uIDEzLDI5MS4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMTQsMTMuNApTYW1wbGUgVHJhbnNhY3Rpb24gMTUsMjg0NzUuMjkKU2FtcGxlIFRyYW5zYWN0aW9uIDE2LDI5MzQuNTkKU2FtcGxlIFRyYW5zYWN0aW9uIDE3LDYzNDIuMjMKU2FtcGxlIFRyYW5zYWN0aW9uIDE4LDEyMzQ1LjY0ClNhbXBsZSBUcmFuc2FjdGlvbiAxOSwxMi4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMjAsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAyMSwyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAyMyw5MjgzLjkyClNhbXBsZSBUcmFuc2FjdGlvbiAyNCwyOTM4NC4yNwpTYW1wbGUgVHJhbnNhY3Rpb24gMjYsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAyNywyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAyOCw0OTMuNTQKU2FtcGxlIFRyYW5zYWN0aW9uIDI5LDI4NDc1LjI5ClNhbXBsZSBUcmFuc2FjdGlvbiAzMiwxMjM0NS42NApTYW1wbGUgVHJhbnNhY3Rpb24gMzMsMTIuMzQKU2FtcGxlIFRyYW5zYWN0aW9uIDM0LDkyODMuOTIKU2FtcGxlIFRyYW5zYWN0aW9uIDM1LDI5Mzg0LjI3ClNhbXBsZSBUcmFuc2FjdGlvbiAzNiwxMi4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMzcsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAzOCwyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAzOSw0OTMuNTQKU2FtcGxlIFRyYW5zYWN0aW9uIDQwLDI4NDc1LjI5ClRvdGFsLDI4OTE1MC4xMw=='
      }
    end

    it 'must delete a file correctly' do
      post '/blobs/create', headers: post_headers, params: valid_json_params, as: :json
      parsed_json = JSON.parse(response.body)
      filename = File.basename(parsed_json.fetch('document_filename', ''))
      id = filename.to_s.downcase.chomp('.json')

      uploaded_file = Base64.decode64(parsed_json.fetch('file', ''))

      delete "/blobs/#{id}", headers: headers

      expect(response.status).to eq 200
    end
  end
end
