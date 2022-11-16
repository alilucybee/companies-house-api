require 'test_helper'

class CompaniesLoaderTest < ActiveSupport::TestCase
  test 'new Companies Loader sets values from environment variables' do
    loader = CompaniesLoader.new
    assert_equal '123', loader.auth[:username]
    assert_equal '', loader.auth[:password]
    assert_equal 'http://www.example.com/', loader.companies_url
    assert_equal 'http://www.example.com/company/', loader.companies_house_api
  end

  test 'setup' do
  end

  test 'fetch_companies' do
  end

  test 'companies_house_url forms the url for the given company number' do
    loader = CompaniesLoader.new
    number = 'SC456'
    blank_number = ''
    assert_equal 'http://www.example.com/company/SC456', loader.companies_house_url(number)
    assert_equal 'http://www.example.com/company/', loader.companies_house_url(blank_number)
  end

  test 'create_companies creates a company if the company number has not already been saved in the database' do
    loader = CompaniesLoader.new
    company = { 'name' => 'Beans Inc', 'number' => '5678' }
    loader.create_companies([company])
    assert_equal 3, Company.count
    assert_includes Company.all.pluck(:name), 'Beans Inc'
  end

  test 'create_companies does not create a company if the company number is already in the database' do
    loader = CompaniesLoader.new
    company = { 'name' => 'Beans Inc', 'number' => Company.first.number }
    loader.create_companies([company])
    assert_equal 2, Company.count
  end

  test 'create_companies raises an error if the JSON is invalid' do
    loader = CompaniesLoader.new
    company = { 'first_name' => 'Bob' }
    assert_raises ActiveModel::UnknownAttributeError do
      loader.create_companies([company])
    end
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
end