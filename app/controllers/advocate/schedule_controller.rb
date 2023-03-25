class Advocate::ScheduleController < Advocate::ApplicationController
  def show
    @presenter = Advocate::SchedulePresenter.new

  end
end
