require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test 'new Company has default values' do
    company = Company.new
    assert_equal '', company.name
    assert_equal '', company.number
    assert_equal false, company.liked
    assert_equal '', company.address
  end
end
