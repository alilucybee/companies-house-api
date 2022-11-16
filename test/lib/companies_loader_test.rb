require 'test_helper'

class CompaniesLoaderTest < ActiveSupport::TestCase
  test 'new Companies Loader sets values from environment variables' do
    loader = CompaniesLoader.new
    assert_equal '123', loader.auth[:username]
    assert_equal '', loader.auth[:password]
    assert_equal 'http://www.example.com/', loader.companies_url
    assert_equal 'http://www.example.com/company/', loader.companies_house_api
  end

  test 'companies_house_url forms the url for the given company number' do
    loader = CompaniesLoader.new
    number = 'SC456'
    blank_number = ''
    assert_equal 'http://www.example.com/company/SC456', loader.companies_house_url(number)
    assert_equal 'http://www.example.com/company/', loader.companies_house_url(blank_number)
  end

  test 'setup returns an array of company and address attributes if both HTTP requests are successful' do
    stub_companies_url_response_ok
    stub_companies_house_response_ok('SC555555')
    stub_companies_house_response_ok('SC666666')
    stub_companies_house_response_ok('SC777777')

    loader = CompaniesLoader.new
    expected_result = [
      { 'name' => 'Apple Inc','number' => 'SC555555', 'address' => 'A Street' },
      { 'name' => 'Banana Inc', 'number' => 'SC666666', 'address' => 'A Street' },
      { 'name' => 'Carrot Inc', 'number' => 'SC777777', 'address' => 'A Street' }
    ]
    assert_equal expected_result, loader.setup
  end

  test 'setup returns an empty array if the first HTTP request fails' do
    stub_companies_url_response_not_ok
    loader = CompaniesLoader.new
    assert_equal [], loader.setup
  end

  test 'create_companies creates a company if the company number has not already been saved in the database' do
    stub_companies_house_response_ok('SC5678')
    loader = CompaniesLoader.new
    company = { 'name' => 'Beans Inc', 'number' => 'SC5678' }
    loader.create_companies([company])
    assert_equal 3, Company.count
    assert_includes Company.all.pluck(:name), 'Beans Inc'
    assert_includes Company.all.pluck(:number), 'SC5678'
  end

  test 'create_companies does not create a company if the company number is already in the database' do
    loader = CompaniesLoader.new
    company = { 'name' => 'Beans Inc', 'number' => Company.first.number }
    loader.create_companies([company])
    assert_equal 2, Company.count
  end

  test 'create_companies raises an error if the JSON is invalid' do
    stub_companies_house_response_no_number_not_ok
    loader = CompaniesLoader.new
    company = { 'first_name' => 'Bob' }
    assert_raises ActiveModel::UnknownAttributeError do
      loader.create_companies([company])
    end
  end

  test 'add_address_data adds the registered_office_address from the companies house API the company if the HTTP request is successful' do
    stub_companies_house_response_ok('SC5678')
    loader = CompaniesLoader.new
    address_data = loader.add_address_data('SC5678')
    assert_equal 'A Street', address_data
  end

  test 'add_address_data returns an empty string if the HTTP request is not successful' do
    stub_companies_house_response_not_ok
    loader = CompaniesLoader.new
    address_data = loader.add_address_data('SC5678')
    assert_equal '', address_data
  end

  test 'parse_address_data parses a json object into a string separated by commas' do
    loader = CompaniesLoader.new
    address_json = {
      'address_line_1' => '7 Holly Close',
      'country' => 'England',
      'locality' => 'Sunbury-On-Thames',
      'postal_code' => 'TW16 6BA'
    }
    parsed_address = loader.parse_address_data(address_json)
    expected_address = '7 Holly Close, England, Sunbury-On-Thames, TW16 6BA'
    assert_equal expected_address, parsed_address
  end

  test 'parse_address_data returns an empty string for nil or blank values' do
    loader = CompaniesLoader.new
    blank_address_json = {}
    nil_address = nil
    assert_equal '', loader.parse_address_data(blank_address_json)
    assert_equal '', loader.parse_address_data(nil_address)
  end

  private

  def companies_json
    [
      { name: 'Apple Inc', number: 'SC555555' },
      { name: 'Banana Inc', number: 'SC666666' },
      { name: 'Carrot Inc', number: 'SC777777' }
    ].to_json
  end

  def address_response
    {
      registered_office_address: {
        address: 'A Street'
      }
    }.to_json
  end

  def stub_companies_url_response_ok
    stub_request(:get, 'http://www.example.com').to_return body: companies_json, headers: {content_type: 'application/json'}, status: 200
  end

  def stub_companies_url_response_not_ok
    stub_request(:get, 'http://www.example.com').to_return body: '{}', headers: {content_type: 'application/json'}, status: 500
  end

  def stub_companies_house_response_ok(number)
    stub_request(:get, "http://www.example.com/company/#{number}").to_return body: address_response, headers: {content_type: 'application/json'}, status: 200
  end

  def stub_companies_house_response_not_ok
    stub_request(:get, 'http://www.example.com/company/SC5678').to_return body: '{}', headers: {content_type: 'application/json'}, status: 500
  end

  def stub_companies_house_response_no_number_not_ok
    stub_request(:get, 'http://www.example.com/company/').to_return body: '{}', headers: {content_type: 'application/json'}, status: 500
  end
end