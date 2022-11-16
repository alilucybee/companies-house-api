class CompaniesLoader
  include HTTParty

  attr_reader :auth, :companies_url, :companies_house_api

  def initialize
    @auth = { username: ENV['API_KEY'], password: ''}
    @companies_url = ENV['COMPANIES_URL']
    @companies_house_api = ENV['COMPANIES_HOUSE_API']
  end

  def setup
    companies = fetch_companies
    create_companies(companies)
  end

  def fetch_companies
    response = HTTParty.get(companies_url)
    return [] if response.code != 200
    JSON.parse(response.body)
  end

  def companies_house_url(registration_number)
    "#{companies_house_api}#{registration_number}"
  end

  def create_companies(companies)
    companies.each do | company |
      number = company['number']
      next if Company.find_by(number: number)
      company['address'] = add_address_data(number)
      Company.create(company)
    end
  end

  def add_address_data(company_number)
    companies_house_response = HTTParty.get(companies_house_url(company_number), { basic_auth: auth })
    return '' if companies_house_response.code != 200
    parsed_response = companies_house_response.parsed_response
    parse_address_data(parsed_response['registered_office_address'])
  end

  def parse_address_data(address_data)
    return '' if !address_data
    address_data.values.join(', ')
  end
end