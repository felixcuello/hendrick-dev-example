# frozen_string_literal: true

module BlobsSvc
  # This service manages the blobs directories
  class Directory
    class << self
      DIRECTORIES = [Constants::TARGET_DIRECTORY_ORIGINAL, Constants::TARGET_DIRECTORY_GCP].freeze

      # list the files
      def list
        result = []

        DIRECTORIES.each do |directory|
          Dir.entries(directory).each do |file|
            file_name = File.join(directory, file)
            result << { file_name:, content_type: Constants::DEFAULT_CONTENT_TYPE } if File.file?(file_name)
          end
        end

        result
      end

      # get one file
      def get_server_file(id:)
        file_path = file_path_by(id:)

        return '' unless file_path

        file = JSON.parse(File.read(file_path))

        {
          file_name: file['filename'],
          content: Base64.decode64(file['file'])
        }
      end

      def file_path_by(id:)
        DIRECTORIES.each do |directory|
          Dir.entries(directory).each do |file|
            file_name = File.join(directory, file)
            return file_name if File.file?(file_name) && (/#{id}/.match file_name)
          end
        end

        nil
      end
    end
  end
end
