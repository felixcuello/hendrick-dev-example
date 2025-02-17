# frozen_string_literal: true

module BlobsSvc
  # This service deletes files given an id
  class Delete
    class << self
      def file(id:)
        file_path = BlobsSvc::Directory.file_path_by(id:)

        return false unless File.exist?(file_path)

        File.delete(file_path)

        true
      end
    end
  end
end
