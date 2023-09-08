class Advocate::ScheduleController < Advocate::ApplicationController
  def monthly_report
    @reporter = Advocate::MonthlyReporter.new(@month)
    @hours_by_status = @reporter.hours_by_employee_status
  end

  def aggregate_report
    start_date = Advocate::Shift.minimum(:date).beginning_of_month
    end_date = Advocate::Shift.maximum(:date)

    months = {}
    while start_date < end_date
      months[start_date] = Advocate::MonthlyReporter.new(start_date)
      start_date += 1.month
    end

    @months = months
  end

  def show
    @current_employee = Advocate::Employee.where(first: "matthew", last: "goggin").first!
    @presenter = Advocate::SchedulePresenter.new(@start_date, @end_date)
  end
end
