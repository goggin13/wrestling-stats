require 'rails_helper'

module Advocate
  RSpec.describe MonthlyReporter, type: :model do
    CSV_FILE = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/30/2023,(F),"Daniels, Michelle",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,,"Glover, Gerica",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,(F),"Godinez, Donna",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,,"Maciha, Emma",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,(F),"peluso riti, stephanie",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,(F),"robin, joshua",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,(F),"royce, cecil",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,,"Rivera, Amanda",ECT,07-12,07:00,12.50
Department: 36102,08/30/2023,,"Smith, Shannon",ECT,07-12,07:00,12.50
Department: 36102,08/30/2023,,"Owens, Adrienne",US,07-12,07:00,12.50
Department: 36102,08/30/2023,,"West, Marguerite",ECT,EX11-08,11:00,8.50
Department: 36102,08/30/2023,,"Goggin, Matthew",RN,11-12,11:00,12.50
Department: 36102,08/30/2023,(F),"Cain, Lisa",ECT,15-08,15:00,8.50
Department: 36102,08/30/2023,,"Gordon, Corrin",ACM,15-08,15:00,8.50
Department: 36102,08/30/2023,(F),"cordero, kenneth",RN,19-12,19:00,12.50
Department: 36102,08/30/2023,(F),"kostryba, khrystyna",RN,19-12,19:00,12.50
Department: 36102,08/30/2023,(F),"Simmons, Marquetta",RN,19-12,19:00,12.50
Department: 36102,08/30/2023,,"WIlliams, Charmakie",RN,19-12,19:00,12.50
Department: 36102,08/30/2023,,"Stachnik, Gabrielle",RN,CHG,19:00,12.50
Department: 36102,08/30/2023,,"Abukhaled, Yazen",RN,TRIAGE,19:00,12.50
Department: 36102,08/30/2023,,"Short, Dawnn",ECT,19-12,19:00,12.50
Department: 36102,08/30/2023,,"Coleman, Leslie",ECT,EX19-12,19:00,12.50
Department: 36102,08/30/2023,,"Millsap, Cassandra",US,19-12,19:00,12.50

CSV

    CSV_FILE_ONE_EMPLOYEE_PER_WEEKDAY = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/14/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/15/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/16/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/17/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/18/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/19/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/20/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50

CSV

    CSV_FILE_MEDIAN_TEST = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/14/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/15/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/15/2023,,"Goggin, Matthew",RN,CHGPREC,07:00,8.50
Department: 36102,08/16/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/16/2023,,"Goggin, Matthew",RN,CHGPREC,07:00,8.50
Department: 36102,08/16/2023,,"Cattenhead, Patricia",RN,CHGPREC,07:00,8.50

CSV

    describe "staffing_grid_for_day" do
      it "returns an map of days to RN staffing numbers and percentages by hour" do
        File.write("tmp/shifts.csv", CSV_FILE)
        CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
        reporter = MonthlyReporter.new(Date.new(2023, 8))

        stub_thresholds = {}
        (0..30).each { |h| stub_thresholds[h % 24] = 10.0 }
        expect(reporter).to receive(:thresholds)
          .at_least(:once)
          .and_return(stub_thresholds)

        grid = reporter.staffing_grid[Date.new(2023, 8, 30)]

        # Day shift
        expect(grid[7][:rn]).to eq({count: 7, pct: 70})
        expect(grid[8][:rn]).to eq({count: 7, pct: 70})
        expect(grid[9][:rn]).to eq({count: 7, pct: 70})
        expect(grid[10][:rn]).to eq({count: 7, pct: 70})

        # Matt comes in
        expect(grid[11][:rn]).to eq({count: 8, pct: 80})
        expect(grid[12][:rn]).to eq({count: 8, pct: 80})
        expect(grid[13][:rn]).to eq({count: 8, pct: 80})
        expect(grid[14][:rn]).to eq({count: 8, pct: 80})

        # Veronica goes home
        expect(grid[15][:rn]).to eq({count: 7, pct: 70})
        expect(grid[16][:rn]).to eq({count: 7, pct: 70})
        expect(grid[17][:rn]).to eq({count: 7, pct: 70})
        expect(grid[18][:rn]).to eq({count: 7, pct: 70})

        # Night shift
        expect(grid[19][:rn]).to eq({count: 6, pct: 60})
        expect(grid[20][:rn]).to eq({count: 6, pct: 60})
        expect(grid[21][:rn]).to eq({count: 6, pct: 60})
        expect(grid[22][:rn]).to eq({count: 6, pct: 60})

        # Matt goes home
        expect(grid[23][:rn]).to eq({count: 5, pct: 50})
        expect(grid[0][:rn]).to eq({count: 5, pct: 50})
        expect(grid[1][:rn]).to eq({count: 5, pct: 50})
        expect(grid[2][:rn]).to eq({count: 5, pct: 50})
        expect(grid[3][:rn]).to eq({count: 5, pct: 50})
        expect(grid[4][:rn]).to eq({count: 5, pct: 50})
        expect(grid[5][:rn]).to eq({count: 5, pct: 50})
        expect(grid[6][:rn]).to eq({count: 5, pct: 50})
      end

      it "returns uses weekend and weekday percentage thresholds" do
        File.write("tmp/shifts.csv", CSV_FILE_ONE_EMPLOYEE_PER_WEEKDAY)
        CsvScheduleParser.parse(
          "tmp/shifts.csv",
          Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
        )
        reporter = MonthlyReporter.new(Date.new(2023, 8))

        stub_thresholds = {}
        (0..30).each { |h| stub_thresholds[h % 24] = 10.0 }
        expect(reporter).to receive(:thresholds)
          .at_least(:once)
          .and_return(stub_thresholds)

        stub_weekend_thresholds = {}
        (0..30).each { |h| stub_weekend_thresholds[h % 24] = 20.0 }
        expect(reporter).to receive(:weekend_thresholds)
          .at_least(:once)
          .and_return(stub_weekend_thresholds)

        mon = reporter.staffing_grid[Date.new(2023, 8, 14)]
        tue = reporter.staffing_grid[Date.new(2023, 8, 15)]
        wed = reporter.staffing_grid[Date.new(2023, 8, 16)]
        thu = reporter.staffing_grid[Date.new(2023, 8, 17)]
        fri = reporter.staffing_grid[Date.new(2023, 8, 18)]
        sat = reporter.staffing_grid[Date.new(2023, 8, 19)]
        sun = reporter.staffing_grid[Date.new(2023, 8, 20)]

        expect(mon[9][:rn][:pct]).to eq(10)
        expect(tue[9][:rn][:pct]).to eq(10)
        expect(wed[9][:rn][:pct]).to eq(10)
        expect(thu[9][:rn][:pct]).to eq(10)
        expect(fri[9][:rn][:pct]).to eq(5)
        expect(sat[9][:rn][:pct]).to eq(5)
        expect(sun[9][:rn][:pct]).to eq(5)
      end

      it "uses the calculated thresholds" do
        File.write("tmp/shifts.csv", CSV_FILE)
        CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
        reporter = MonthlyReporter.new(Date.new(2023, 8))

        grid = reporter.staffing_grid[Date.new(2023, 8, 30)]

        expect(grid[7][:rn]).to eq({count: 7, pct: 117})
      end

      it "ignores ORF shifts" do
        File.write("tmp/shifts.csv", CSV_FILE)
        CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
        rn = FactoryBot.create(:advocate_employee, role: "RN")
        FactoryBot.create(:advocate_shift,
                          employee: rn,
                          date: Date.new(2023, 8, 30),
                          start: 7, duration: 12,
                          raw_shift_code: "ORF")

        reporter = MonthlyReporter.new(Date.new(2023, 8))

        grid = reporter.staffing_grid[Date.new(2023, 8, 30)]

        expect(grid[7][:rn][:count]).to eq(7)
      end
    end

    describe "hours_by_employee_status" do
      it "returns a hash of hours worked" do
        # edwards, veronica (FullTime) : 8
        # glover, gerica (FullTime) : 12
        # maciha, emma (FullTime) : 12
        # goggin, matthew (FullTime) : 12
        # williams, charmakie (FullTime) : 12
        # stachnik, gabrielle (FullTime) : 12
        # abukhaled, yazen (FullTime) : 12
        #
        # daniels, michelle (PartTime) : 12
        #
        # peluso riti, stephanie (Agency) : 12
        # robin, joshua (Agency) : 12
        # royce, cecil (Agency) : 12
        # cordero, kenneth (Agency) : 12
        # kostryba, khrystyna (Agency) : 12
        File.write("tmp/shifts.csv", CSV_FILE)
        CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)

        full_time = [8,12,12,12,12,12,12].sum
        part_time = [12].sum
        agency = [12,12,12,12,12].sum
        total = full_time + part_time + agency

        full_time_pct = (full_time / total.to_f * 100).round(2)
        part_time_pct = (part_time / total.to_f * 100).round(2)
        agency_pct = (agency / total.to_f * 100).round(2)

        reporter = MonthlyReporter.new(Date.new(2023, 8))

        expect(reporter.hours_by_employee_status).to eq({
          total: total,
          full_time: {hours: full_time, pct: full_time_pct},
          part_time: {hours: part_time, pct: part_time_pct},
          agency: {hours: agency, pct: agency_pct},
        })
      end
    end

    describe "median" do
      it "lists a breakdown of advocate vs agency employees" do
        File.write("tmp/shifts.csv", CSV_FILE_MEDIAN_TEST)
        CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)

        reporter = MonthlyReporter.new(Date.new(2023, 8))

        stub_thresholds = {}
        (0..30).each { |h| stub_thresholds[h % 24] = 10.0 }
        expect(reporter).to receive(:thresholds)
          .at_least(:once)
          .and_return(stub_thresholds)

        expect(reporter.median_pct).to eq(20)
      end
    end
  end

  describe "orientees" do
    it "does not include employees who have a full time shift worked that month" do
      employee = FactoryBot.create(:advocate_employee, :full_time)
      date = Date.new(2023, 8, 23)
      FactoryBot.create(:advocate_shift, employee: employee,
                        raw_shift_code: "ORF", date: date)
      FactoryBot.create(:advocate_shift, employee: employee, date: date)

      reporter = MonthlyReporter.new(Date.new(2023, 8))

      expect(reporter.full_timers.map(&:id)).to include(employee.id)
      expect(reporter.orientees.map(&:id)).to_not include(employee.id)
    end

    it "does not include techs" do
      employee = FactoryBot.create(:advocate_employee, :full_time, role: "ECT")
      date = Date.new(2023, 8, 23)
      FactoryBot.create(:advocate_shift, employee: employee,
                        raw_shift_code: "ORF", date: date)

      reporter = MonthlyReporter.new(Date.new(2023, 8))

      expect(reporter.orientees.map(&:id)).to_not include(employee.id)
    end
  end

  describe "theshold definitions" do
    it "uses the calculated weekend thresholds" do
      File.write("tmp/shifts.csv", CSV_FILE)
      CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
      reporter = MonthlyReporter.new(Date.new(2023, 8))

      thresholds = reporter.weekend_thresholds

      expect(thresholds[7]).to eq(6)
      expect(thresholds[8]).to eq(6)
      expect(thresholds[9]).to eq(7)
      expect(thresholds[10]).to eq(7)
      expect(thresholds[11]).to eq(9)
      expect(thresholds[12]).to eq(9)
      expect(thresholds[13]).to eq(9)
      expect(thresholds[14]).to eq(9)
      expect(thresholds[15]).to eq(9)
      expect(thresholds[16]).to eq(9)
      expect(thresholds[17]).to eq(9)
      expect(thresholds[18]).to eq(9)
      expect(thresholds[19]).to eq(8)
      expect(thresholds[20]).to eq(8)
      expect(thresholds[21]).to eq(7)
      expect(thresholds[22]).to eq(7)
      expect(thresholds[23]).to eq(7)
      expect(thresholds[0]).to eq(7)
      expect(thresholds[1]).to eq(7)
      expect(thresholds[2]).to eq(7)
      expect(thresholds[3]).to eq(6)
      expect(thresholds[4]).to eq(6)
      expect(thresholds[5]).to eq(6)
      expect(thresholds[6]).to eq(6)
    end

    it "uses the calculated weekday thresholds" do
      File.write("tmp/shifts.csv", CSV_FILE)
      CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
      reporter = MonthlyReporter.new(Date.new(2023, 8))

      thresholds = reporter.thresholds

      expect(thresholds[7]).to eq(6)
      expect(thresholds[8]).to eq(6)
      expect(thresholds[9]).to eq(8)
      expect(thresholds[10]).to eq(8)
      expect(thresholds[11]).to eq(10)
      expect(thresholds[12]).to eq(10)
      expect(thresholds[13]).to eq(10)
      expect(thresholds[14]).to eq(10)
      expect(thresholds[15]).to eq(10)
      expect(thresholds[16]).to eq(10)
      expect(thresholds[17]).to eq(10)
      expect(thresholds[18]).to eq(10)
      expect(thresholds[19]).to eq(8)
      expect(thresholds[20]).to eq(8)
      expect(thresholds[21]).to eq(7)
      expect(thresholds[22]).to eq(7)
      expect(thresholds[23]).to eq(7)
      expect(thresholds[0]).to eq(7)
      expect(thresholds[1]).to eq(7)
      expect(thresholds[2]).to eq(7)
      expect(thresholds[3]).to eq(5)
      expect(thresholds[4]).to eq(5)
      expect(thresholds[5]).to eq(5)
      expect(thresholds[6]).to eq(5)
    end
  end
end
