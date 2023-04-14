class Advocate::ScheduleController < Advocate::ApplicationController
  def show
    @current_employee = Advocate::Employee.where(first: "Matt", last: "Goggin").first!
    @presenter = Advocate::SchedulePresenter.new
  end
end
