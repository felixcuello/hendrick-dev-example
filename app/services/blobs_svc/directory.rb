# frozen_string_literal: true

module BlobsSvc
  # This service manages the blobs directories
  class Directory
    class << self
      # list the files
      def list
        result = []
        directories = [Constants::TARGET_DIRECTORY_ORIGINAL, Constants::TARGET_DIRECTORY_GCP]

        directories.each do |directory|
          Dir.entries(directory).each do |file|
            file_name = File.join(directory, file)
            result << { file_name:, content_type: Constants::DEFAULT_CONTENT_TYPE } if File.file?(file_name)
          end
        end

        result
      end
    end
  end
end
