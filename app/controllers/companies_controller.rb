class CompaniesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :render_unexpected_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveModel::UnknownAttributeError, with: :render_unexpected_error

  before_action :fetch_companies, only: [:index]

  def index
    @companies = Company.all
    render_not_found and return if @companies.empty?
  end

  def update
    company = Company.find_by(number: update_params[:number])
    render_not_found and return if company.nil?

    if company.update(liked: update_params[:liked])
      head :ok
    else
      render_unexpected_error
    end
  end

  private

  def update_params
    params.require(:company).permit(:number, :liked)
  end

  def render_not_found
    render :not_found, status: :not_found
  end

  def render_unexpected_error
    render :unexpected_error, status: :unprocessable_entity
  end

  def fetch_companies
    latest_companies = CompaniesLoader.new
    latest_companies.setup
  end
end
