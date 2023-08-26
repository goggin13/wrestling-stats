class Advocate::ScheduleController < Advocate::ApplicationController

  def show
    @current_employee = Advocate::Employee.where(first: "Matt", last: "Goggin").first!
    @presenter = Advocate::SchedulePresenter.new(@start_date, @end_date)
  end

  def index
    @shifts = Advocate::Shift
      .where(date: @start_date..@end_date)
      .order(date: :ASC, start: :ASC)
      .all
  end
end
