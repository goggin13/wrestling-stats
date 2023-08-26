class Advocate::EmployeeController < Advocate::ApplicationController
  def index
    @presenter = Advocate::EmployeePresenter.new(@start_date, @end_date)
    @staff_counts = @presenter.staff_counts
    @hours_breakdown = @presenter.hours_breakdown
  end
end
