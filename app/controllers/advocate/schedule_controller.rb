class Advocate::ScheduleController < Advocate::ApplicationController
  def monthly_report
    if params[:month].present?
      @month = Date.strptime(params[:month], "%m/%y")
    else
      @month = Date.today.beginning_of_month
    end
    @start_date = @month
    @end_date = @month.end_of_month
    @prev_month = (@start_date - 1.days).beginning_of_month.strftime("%m/%y")
    @next_month = (@end_date + 1.days).beginning_of_month.strftime("%m/%y")

    @reporter = Advocate::MonthlyReporter.new(@month)
    @hours_by_status = @reporter.hours_by_employee_status
  end

  def show
    @current_employee = Advocate::Employee.where(first: "matthew", last: "goggin").first!
    @presenter = Advocate::SchedulePresenter.new(@start_date, @end_date)
  end
end
