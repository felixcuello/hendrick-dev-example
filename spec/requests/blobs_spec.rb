require "rails_helper"

RSpec.describe "Blobs", type: :request do
  include_context :with_basic_authorization

  let(:valid_json_params) {
    {
      filename: "sample_file_that_needs_to_be_adjusted.csv",
      file_size: "1324",
      encoding_format: "UTF-8",
      file: "ZGVzY3JpcHRpb24sYW1vdW50DQpTYW1wbGUgVHJhbnNhY3Rpb24gMSwxMjMuMDUNClNhbXBsZSBUcmFuc2FjdGlvbiAyLDU4NDMuNzUNClNhbXBsZSBUcmFuc2FjdGlvbiAzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiA0LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gNSwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDYsMjkxMy44DQpTYW1wbGUgVHJhbnNhY3Rpb24gNywyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiA5LDg3NC4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDEwLDE4MjAuMTgNClNhbXBsZSBUcmFuc2FjdGlvbiAxMSwxODIuMg0KU2FtcGxlIFRyYW5zYWN0aW9uIDEyLDk4NzYuMjQNClNhbXBsZSBUcmFuc2FjdGlvbiAxMywyOTEuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAxNCwxMy40DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTUsMjg0NzUuMjkNClNhbXBsZSBUcmFuc2FjdGlvbiAxNiwyOTM0LjU5DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTcsNjM0Mi4yMw0KU2FtcGxlIFRyYW5zYWN0aW9uIDE4LDEyMzQ1LjY0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMTksMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAyMCwyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAyMSwyOTM5LjgzDQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDQ5My41NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDIzLDkyODMuOTINClNhbXBsZSBUcmFuc2FjdGlvbiAyNCwyOTM4NC4yNw0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwxMi4zNA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI2LDI5MTMuOA0KU2FtcGxlIFRyYW5zYWN0aW9uIDI3LDI5MzkuODMNClNhbXBsZSBUcmFuc2FjdGlvbiAyOCw0OTMuNTQNClNhbXBsZSBUcmFuc2FjdGlvbiAyOSwyODQ3NS4yOQ0KbWVjaGFuaW5jYWwgYnVzaW5lc3MgdHJhbnNvZm9ybWF0aW9uIEdDUCwyOTM0LjU5DQptZWNoYW5pbmNhbCBidXNpbmVzcyB0cmFuc29mb3JtYXRpb24gR0NQLDYzNDIuMjMNClNhbXBsZSBUcmFuc2FjdGlvbiAzMiwxMjM0NS42NA0KU2FtcGxlIFRyYW5zYWN0aW9uIDMzLDEyLjM0DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzQsOTI4My45Mg0KU2FtcGxlIFRyYW5zYWN0aW9uIDM1LDI5Mzg0LjI3DQpTYW1wbGUgVHJhbnNhY3Rpb24gMzYsMTIuMzQNClNhbXBsZSBUcmFuc2FjdGlvbiAzNywyOTEzLjgNClNhbXBsZSBUcmFuc2FjdGlvbiAzOCwyOTM5LjgzDQpTYW1wbGUgVHJhbnNhY3Rpb24gMzksNDkzLjU0DQpTYW1wbGUgVHJhbnNhY3Rpb24gNDAsMjg0NzUuMjkNClRvdGFsLDI4OTE1MC4xMw=="
    }
  }

  describe "POST /" do
    it "creates a file when passed JSON" do
      headers = {
        Authorization: basic_authorization,
        "Content-Type": "application/json",
        "X-Request-Id": "a-correlation-id"
      }

      post "/blobs/create", headers: headers, params: valid_json_params, as: :json
      expect(response).to have_http_status(:created)
      expect(response).to match_json_schema("blobs")
    end
  end
end
