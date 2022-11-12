require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  test '#index assigns companies' do
    get companies_path
    companies = assigns(:companies)
    assert_equal 2, companies.count
  end

  test '#index returns 200 response when successful' do
    get companies_path
    assert_response 200
  end
end
