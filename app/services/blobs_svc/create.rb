require 'csv'
require 'securerandom'

TARGET_DIRECTORY_ORIGINAL = 'received_files'
TARGET_DIRECTORY_GCP = 'received_files/gcp'
MECHANICAL_BUSINESS_TRANSFORMATION = 'mechanincal business transoformation GCP'
NEWLINE = "\r\n"

module BlobsSvc
  # Creates a new Blobs file
  class Create
    class << self
      def file(json:)
        uuid = SecureRandom.uuid

        json = store_original_file(json:, uuid:)
        json = maybe_store_gcp_adjusted_file(json:, uuid:)

        json
      rescue StandardError
        puts "File creation failed!"
      ensure
        json || {}
      end

      private

      def store_original_file(json:, uuid:)
        filename = "#{TARGET_DIRECTORY_ORIGINAL}/#{uuid}.json"

        json['document_id'] = uuid
        json['document_filename'] = filename

        File.write(filename, JSON.pretty_generate(json))

        json
      rescue StandardError => e
        puts "Something bad happened while processing original file #{filename}"
        raise e
      end

      def maybe_store_gcp_adjusted_file(json:, uuid:)
        filename = "#{TARGET_DIRECTORY_GCP}/#{uuid}.json"

        gcp_sum = 0
        adjusted = false

        file = Base64.decode64(json.fetch('file', '==='))

        adjusted_csv = CSV.generate(row_sep: NEWLINE) do |csv_out|
          csv_out << ['description', 'amount'] # TODO: This should be the real header

          CSV.parse(file, headers: true) do |row|
            case row['description']
            when MECHANICAL_BUSINESS_TRANSFORMATION
              adjusted = true
              gcp_sum += row['amount'].to_f # TODO: This could have a floating point problem
            when /^total$/i
              csv_out << ["#{MECHANICAL_BUSINESS_TRANSFORMATION} - consolidated", gcp_sum]
              csv_out << ["#{MECHANICAL_BUSINESS_TRANSFORMATION} - consolidated", -gcp_sum]
            end

            csv_out << [row['description'], row['amount']]
          end
        end

        if adjusted
          json['original_file'] = json['file']
          json['file'] = Base64.strict_encode64(adjusted_csv.chomp(NEWLINE))
          json['document_gcp_filename'] = filename

          File.write(filename, JSON.pretty_generate(json))
        end

        json
      rescue StandardError => e
        puts "Something bad happened while processing GCP file #{filename}"
        raise e
      end
    end
  end
end
