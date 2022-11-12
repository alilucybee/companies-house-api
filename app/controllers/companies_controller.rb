class CompaniesController < ApplicationController

  def index
    @companies = [
      {name: "ACME", number: "1234"},
      {name: "Bull", number: "5678"}
    ]
  end
end
