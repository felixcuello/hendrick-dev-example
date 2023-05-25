# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blobs', type: :request do
  include_context :with_basic_authorization

  describe 'POST /blobs/create' do
    let(:headers) { { Authorization: basic_authorization, 'Content-Type': 'application/json', 'X-Request-Id': 'a-correlation-id' } }

    # ---------------------------------------------------------------------------
    it 'must reject unauthorized POST calls' do
      get '/blobs', as: :json

      expect(response.status).to eq 401
    end

    # ---------------------------------------------------------
    context 'when the file does not require adjustments' do
      let(:valid_json_params) do
        {
          filename: 'sample_file_that_does_not_need_to_be_adjusted.csv',
          file_size: '1324',
          encoding_format: 'UTF-8',
          file: 'ZGVzY3JpcHRpb24sYW1vdW50ClNhbXBsZSBUcmFuc2FjdGlvbiAxLDEyMy4wNQpTYW1wbGUgVHJhbnNhY3Rpb24gMiw1ODQzLjc1ClNhbXBsZSBUcmFuc2FjdGlvbiAzLDkyODMuOTIKU2FtcGxlIFRyYW5zYWN0aW9uIDQsMjkzODQuMjcKU2FtcGxlIFRyYW5zYWN0aW9uIDUsMTIuMzQKU2FtcGxlIFRyYW5zYWN0aW9uIDYsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiA3LDI5MzkuODMKU2FtcGxlIFRyYW5zYWN0aW9uIDgsNDkzLjU0ClNhbXBsZSBUcmFuc2FjdGlvbiA5LDg3NC4yMwpTYW1wbGUgVHJhbnNhY3Rpb24gMTAsMTgyMC4xOApTYW1wbGUgVHJhbnNhY3Rpb24gMTEsMTgyLjIKU2FtcGxlIFRyYW5zYWN0aW9uIDEyLDk4NzYuMjQKU2FtcGxlIFRyYW5zYWN0aW9uIDEzLDI5MS4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMTQsMTMuNApTYW1wbGUgVHJhbnNhY3Rpb24gMTUsMjg0NzUuMjkKU2FtcGxlIFRyYW5zYWN0aW9uIDE2LDI5MzQuNTkKU2FtcGxlIFRyYW5zYWN0aW9uIDE3LDYzNDIuMjMKU2FtcGxlIFRyYW5zYWN0aW9uIDE4LDEyMzQ1LjY0ClNhbXBsZSBUcmFuc2FjdGlvbiAxOSwxMi4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMjAsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAyMSwyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAyMyw5MjgzLjkyClNhbXBsZSBUcmFuc2FjdGlvbiAyNCwyOTM4NC4yNwpTYW1wbGUgVHJhbnNhY3Rpb24gMjYsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAyNywyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAyOCw0OTMuNTQKU2FtcGxlIFRyYW5zYWN0aW9uIDI5LDI4NDc1LjI5ClNhbXBsZSBUcmFuc2FjdGlvbiAzMiwxMjM0NS42NApTYW1wbGUgVHJhbnNhY3Rpb24gMzMsMTIuMzQKU2FtcGxlIFRyYW5zYWN0aW9uIDM0LDkyODMuOTIKU2FtcGxlIFRyYW5zYWN0aW9uIDM1LDI5Mzg0LjI3ClNhbXBsZSBUcmFuc2FjdGlvbiAzNiwxMi4zNApTYW1wbGUgVHJhbnNhY3Rpb24gMzcsMjkxMy44ClNhbXBsZSBUcmFuc2FjdGlvbiAzOCwyOTM5LjgzClNhbXBsZSBUcmFuc2FjdGlvbiAzOSw0OTMuNTQKU2FtcGxlIFRyYW5zYWN0aW9uIDQwLDI4NDc1LjI5ClRvdGFsLDI4OTE1MC4xMw=='
        }
      end

      # ---------------------------------------------------------
      it 'creates a file when passed JSON' do
        post '/blobs/create', headers:, params: valid_json_params, as: :json

        expect(response).to have_http_status(:created)
        expect(response).to match_json_schema('blobs')
      end

      # ---------------------------------------------------------
      it 'must store the original file' do
        post '/blobs/create', headers:, params: valid_json_params, as: :json

        document_filename = JSON.parse(response.body).fetch('document_filename','')

        stored_file = Base64.decode64(JSON.parse(File.read(document_filename)).fetch('file', ''))
        expected_file = Base64.decode64(valid_json_params[:file])

        expect(stored_file).to eq expected_file
      end
    end

    # ---------------------------------------------------------
    #  The file REQUIRES an adjustment
    # ---------------------------------------------------------
    context 'when the file REQUIRES adjustments' do
      let(:valid_json_params_that_require_adjustment) do
        {
          filename: 'sample_file_that_does_not_need_to_be_adjusted.csv',
          file_size: '1324',
          encoding_format: 'UTF-8',
          file: 'ZGVzY3JpcHRpb24sYW1vdW50DQpTYW1wbGUgVHJhbnNhY3Rpb24gMSwxMjMuMDUNClNhbXBsZSBUcmFuc2FjdGlvbiAyLDU4NDMuNzUNClNhbXBsZSBUcmFuc2FjdGlvbiAzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiA0LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gNSwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDYsMjkxMy44DQpTYW1wbGUgVHJhbnNhY3Rpb24gNywyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiA5LDg3NC4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDEwLDE4MjAuMTgNClNhbXBsZSBUcmFuc2FjdGlvbiAxMSwxODIuMg0KU2FtcGxlIFRyYW5zYWN0aW9uIDEyLDk4NzYuMjQNClNhbXBsZSBUcmFuc2FjdGlvbiAxMywyOTEuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAxNCwxMy40DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTUsMjg0NzUuMjkNClNhbXBsZSBUcmFuc2FjdGlvbiAxNiwyOTM0LjU5DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTcsNjM0Mi4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDE4LDEyMzQ1LjY0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTksMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAyMCwyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAyMSwyOTM5LjgzDQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDQ5My41NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDIzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiAyNCwyOTM4NC4yNw0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI2LDI5MTMuOA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI3LDI5MzkuODMNClNhbXBsZSBUcmFuc2FjdGlvbiAyOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiAyOSwyODQ3NS4yOQ0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwyOTM0LjU5DQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDYzNDIuMjMNClNhbXBsZSBUcmFuc2FjdGlvbiAzMiwxMjM0NS42NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDMzLDEyLjM0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzQsOTI4My45Mg0KU2FtcGxlIFRyYW5zYWN0aW9uIDM1LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzYsMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAzNywyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAzOCwyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gMzksNDkzLjU0DQpTYW1wbGUgVHJhbnNhY3Rpb24gNDAsMjg0NzUuMjkNClRvdGFsLDI4OTE1MC4xMw==',
          adjusted_file: 'ZGVzY3JpcHRpb24sYW1vdW50DQpTYW1wbGUgVHJhbnNhY3Rpb24gMSwxMjMuMDUNClNhbXBsZSBUcmFuc2FjdGlvbiAyLDU4NDMuNzUNClNhbXBsZSBUcmFuc2FjdGlvbiAzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiA0LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gNSwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDYsMjkxMy44DQpTYW1wbGUgVHJhbnNhY3Rpb24gNywyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiA5LDg3NC4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDEwLDE4MjAuMTgNClNhbXBsZSBUcmFuc2FjdGlvbiAxMSwxODIuMg0KU2FtcGxlIFRyYW5zYWN0aW9uIDEyLDk4NzYuMjQNClNhbXBsZSBUcmFuc2FjdGlvbiAxMywyOTEuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAxNCwxMy40DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTUsMjg0NzUuMjkNClNhbXBsZSBUcmFuc2FjdGlvbiAxNiwyOTM0LjU5DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTcsNjM0Mi4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDE4LDEyMzQ1LjY0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTksMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAyMCwyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAyMSwyOTM5LjgzDQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDQ5My41NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDIzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiAyNCwyOTM4NC4yNw0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI2LDI5MTMuOA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI3LDI5MzkuODMNClNhbXBsZSBUcmFuc2FjdGlvbiAyOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiAyOSwyODQ3NS4yOQ0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwyOTM0LjU5DQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDYzNDIuMjMNClNhbXBsZSBUcmFuc2FjdGlvbiAzMiwxMjM0NS42NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDMzLDEyLjM0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzQsOTI4My45Mg0KU2FtcGxlIFRyYW5zYWN0aW9uIDM1LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzYsMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAzNywyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAzOCwyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gMzksNDkzLjU0DQpTYW1wbGUgVHJhbnNhY3Rpb24gNDAsMjg0NzUuMjkNCm1lY2hhbmluY2FsIGJ1c2luZXNzIHRyYW5zb2Zvcm1hdGlvbiBHQ1AgLSBjb25zb2xpZGF0ZWQsOTc4Mi43DQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQIC0gY29uc29saWRhdGVkLC05NzgyLjcNClRvdGFsLDI4OTE1MC4xMw=='
        }
      end

      # ---------------------------------------------------------
      it 'returns an adjusted GCP file' do
        post '/blobs/create', headers:, params: valid_json_params_that_require_adjustment, as: :json

        server_file = JSON.parse(response.body)
        expect(server_file.fetch('adjusted_file', '')).to eq(valid_json_params_that_require_adjustment[:adjusted_file])
      end

      # ---------------------------------------------------------
      it 'creates a file when passed JSON' do
        post '/blobs/create', headers:, params: valid_json_params_that_require_adjustment, as: :json

        expect(response).to have_http_status(:created)
        expect(response).to match_json_schema('blobs')
      end

      # ---------------------------------------------------------
      it 'must store the adjusted file' do
        post '/blobs/create', headers:, params: valid_json_params_that_require_adjustment, as: :json

        document_filename = JSON.parse(response.body).fetch('document_gcp_filename','')

        stored_file = Base64.decode64(JSON.parse(File.read(document_filename)).fetch('file', ''))
        expected_file = Base64.decode64(valid_json_params_that_require_adjustment[:adjusted_file])

        expect(stored_file).to eq expected_file
      end

      # ---------------------------------------------------------
      it 'must store the original file' do
        post '/blobs/create', headers:, params: valid_json_params_that_require_adjustment, as: :json

        document_filename = JSON.parse(response.body).fetch('document_filename','')

        stored_file = Base64.decode64(JSON.parse(File.read(document_filename)).fetch('file', ''))
        expected_file = Base64.decode64(valid_json_params_that_require_adjustment[:file])

        expect(stored_file).to eq expected_file
      end
    end
  end
end
