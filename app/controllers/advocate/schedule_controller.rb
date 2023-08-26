class Advocate::ScheduleController < Advocate::ApplicationController

  def show
    @current_employee = Advocate::Employee.where(first: "Matt", last: "Goggin").first!
    @presenter = Advocate::SchedulePresenter.new(@start_date, @end_date)
  end

  def index
    @shifts = Advocate::Shift.all.order(date: :ASC, start: :ASC)
  end
end
