class Advocate::ScheduleController < Advocate::ApplicationController
  def monthly_report
    @reporter = Advocate::MonthlyReporter.new(@month)
    @hours_by_status = @reporter.hours_by_employee_status
  end

  def show
    @current_employee = Advocate::Employee.where(first: "matthew", last: "goggin").first!
    @presenter = Advocate::SchedulePresenter.new(@start_date, @end_date)
  end
end
