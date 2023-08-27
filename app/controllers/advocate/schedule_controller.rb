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

  def staffing_data
    query=<<SQL
select
  least(floor(rn_pct/10)*10,100) as bucket,
  count(*)
from advocate_staffing_hours SH
where SH.date >= '#{@start_date}' and SH.date <= '#{@end_date}'
group by 1
order by 1 ASC;
SQL
    @histogram = ActiveRecord::Base.connection.exec_query(query)
    @staffing_hours = Advocate::StaffingHour
      .where(date: @start_date..@end_date)
      .order(date: :ASC, hour: :ASC)
      .inject({}) do |acc, staffing_hour|
        acc[staffing_hour.date] ||= []
        acc[staffing_hour.date] << staffing_hour

        acc
      end
  end
end
