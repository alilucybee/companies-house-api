ENV['RAILS_ENV'] ||= 'test'
ENV['API_KEY'] = '123'
ENV['COMPANIES_URL'] = 'http://www.example.com/'
ENV['COMPANIES_HOUSE_API'] = 'http://www.example.com/company/'
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
