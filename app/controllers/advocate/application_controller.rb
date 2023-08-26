class Advocate::ApplicationController < ApplicationController
  layout "advocate/application"
  before_action :parse_dates

  def parse_dates
    if params[:end_date].present?
      @end_date = Date.parse(params[:end_date])
    else
      @end_date = Advocate::Shift.maximum(:date)
    end
    @start_date = @end_date - 27.days

    dir = "file:///Users/goggin/Documents/projects/dumbledore/spec/download_fixtures/advocate/archive/"
    file_name = "schedule_#{@start_date.strftime("%Y-%m-%d")}%23#{@end_date.strftime("%Y-%m-%d")}.html"
    @schedule_path = "#{dir}/#{file_name}"

    Rails.logger.info "[INFO] Showing data for #{@start_date} to #{@end_date}"
  end
end
