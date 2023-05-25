# frozen_string_literal: true

require 'csv'
require 'securerandom'

MECHANICAL_BUSINESS_TRANSFORMATION = 'mechanincal business transoformation GCP'
NEWLINE = "\r\n"

module BlobsSvc
  # Creates a new Blobs file
  class Create
    def initialize(json:)
      @json = json
    end

    #  Service object main action
    # ---------------------------------------------------------
    def create_file
      uuid = SecureRandom.uuid

      store_original_file(uuid:)
      maybe_store_gcp_adjusted_file(uuid:)

      @json
    rescue StandardError => e
      require 'pry'; binding.pry # XXX: REMOVE THIS
      puts 'File creation failed!'
    ensure
      @json || {}
    end

    private

    #  Stores the original CSV file
    # ---------------------------------------------------------
    def store_original_file(uuid:)
      filename = "#{Constants::TARGET_DIRECTORY_ORIGINAL}/#{uuid}.json"

      @json['document_id'] = uuid
      @json['document_filename'] = filename

      File.write(filename, JSON.pretty_generate(@json))
    rescue StandardError => e
      puts "Something bad happened while processing original file #{filename}"
      raise e
    end

    #  If the file has a MECHANICAL_BUSINESS_TRANSFORMATION
    #  it processes it, and stores it in the gcp directory
    # ------------------------------------------------------
    def maybe_store_gcp_adjusted_file(uuid:)
      filename = "#{Constants::TARGET_DIRECTORY_GCP}/#{uuid}.json"

      gcp_sum = 0
      adjusted = false

      file = Base64.decode64(@json.fetch('file', '==='))

      adjusted_csv = CSV.generate(row_sep: NEWLINE) do |csv_out|
        csv_out << %w[description amount] # TODO: This should be the real header

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

      store_gcp_adjusted_file(adjusted_csv:, filename:) if adjusted
    rescue StandardError => e
      puts "Something bad happened while processing GCP file #{filename}"
      raise e
    end

    #  Stores the gcp adjusted file and update JSON metadata
    # ---------------------------------------------------------
    def store_gcp_adjusted_file(adjusted_csv:, filename:)
      @json['original_file'] = @json['file']
      @json['file'] = Base64.strict_encode64(adjusted_csv.chomp(NEWLINE))
      @json['document_gcp_filename'] = filename

      begin
        File.write(filename, JSON.pretty_generate(@json))
      rescue StandardError => e
        puts "Problem saving #{filename}"
        raise e
      end
    end
  end
end
