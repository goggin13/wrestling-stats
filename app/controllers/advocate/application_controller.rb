class Advocate::ApplicationController < ApplicationController
  layout "advocate/application"
  before_action :parse_dates

  def parse_dates
    if params[:month].present?
      @month = Date.strptime(params[:month], "%m/%y")
    else
      @month = Date.today.beginning_of_month
    end
    @start_date = @month
    @end_date = @month.end_of_month
    @prev_month = @start_date - 1.days
    @next_month = @end_date + 1.days
  end
end
