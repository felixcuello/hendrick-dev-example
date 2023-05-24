require 'securerandom'

module BlobsSvc
  # Creates a new Blobs file
  class Create
    class << self
      def file(directory:, json:)
        uuid = SecureRandom.uuid
        filename = "#{directory.to_s.chomp('/')}/#{uuid}.json"

        json['document_id'] = uuid
        json['document_filename'] = filename

        File.write(filename, JSON.pretty_generate(json))

        json
      rescue StandardError
        puts "Something bad happened while processing file #{filename}"
      ensure
        json || {}
      end
    end
  end
end
