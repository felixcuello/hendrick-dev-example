# frozen_string_literal: true

RSpec.configure do |config|
  config.include(ActiveJob::TestHelper)

  config.before(:all) do
    ActiveJob::Base.queue_adapter = :test
  end
end
