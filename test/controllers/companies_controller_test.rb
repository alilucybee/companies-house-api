require 'test_helper'

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test '#index assigns all the companies from the database' do
    stub_companies_http_request
    get companies_path
    displayed_companies = assigns(:companies)
    assert_equal 2, displayed_companies.count
    assert_includes displayed_companies, Company.first
    assert_includes displayed_companies, Company.second
  end

  test '#index returns 200 ok response when companies are found' do
    stub_companies_http_request
    get companies_path
    assert_response 200
  end

  test '#index returns 404 not found response when there are no companies' do
    stub_companies_http_request
    Company.destroy_all
    get companies_path
    assert_response 404
  end

  test '#update updates the liked value of the Company using the params' do
    company = Company.second
    valid_params = { company: { number: company.number, liked: true } }
    refute company.liked
    patch company_path, params: valid_params
    assert company.reload.liked
  end

  test '#update returns 200 ok response on success' do
    company = Company.first
    valid_params = { company: { number: company.number, liked: true } }
    patch company_path, params: valid_params
    assert_response 200
  end

  test '#update returns 404 not found response if company to be updated does not exist' do
    invalid_params = { company: { number: '1', liked: true } }
    patch company_path, params: invalid_params
    assert_response 404
  end

  private

  def stub_companies_http_request
    stub_request(:get, "http://www.example.com/").to_return(status: 200, body: '{}', headers: {})
  end

  # TODO: raise 422 error
  # test '#update returns 422 unprocessable entity if update fails' do
  #   company = Company.first
  #   invalid_params = { company: { number: company.number, liked: company.liked } }
  #   patch company_path, params: invalid_params
  #   assert_response 422
  # end
end
