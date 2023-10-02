require 'rails_helper'

module Advocate
  RSpec.describe SchedulePresenter, type: :model do
    before do
      @csv_file = <<-CSV
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
    end

    def verify_shifts_contain(shifts, last, role, start, duration)
      matches = shifts.select do |shift|
        success = shift.employee.last == last &&
          shift.employee.role == role &&
          shift.start == start &&
          shift.duration == duration

        success
      end

      # puts shifts
      # puts "Checking #{last}:#{role} start:#{start} on #{shifts.first.date}"
      expect(matches.length).to eq(1)
    end

    def verify_shift(shift, last, role, start, duration)
      verify_shifts_contain([shift], last, role, start, duration)
    end

    before do
      File.write("tmp/shifts.csv", @csv_file)
      CsvScheduleParser.parse("tmp/shifts.csv", Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)

      @presenter = SchedulePresenter.new(Date.new(2023,8,1), Date.new(2023,8,31))
    end

    describe "shifts_for" do
      it "passes an integration spec" do
        shifts = @presenter.shifts_for(Date.new(2023,8,30))

        # Day RNs
        [
          ["daniels", "RN", 7, 12],
          ["edwards", "RN", 7, 8],
          ["glover", "RN", 7, 12],
          ["maciha", "RN", 7, 12],
          ["peluso riti", "RN", 7, 12],
          ["robin", "RN", 7, 12],
          ["royce", "RN", 7, 12],
        ].each do |args|
          verify_shifts_contain(shifts[:day][:rns], *args)
        end
        expect(shifts[:day][:rns].length).to eq(7)

        # Day Techs
        [
          ["rivera", "ECT", 7, 12],
          ["smith", "ECT", 7, 12],
        ].each do |args|
          verify_shifts_contain(shifts[:day][:techs], *args)
        end
        expect(shifts[:day][:techs].length).to eq(2)

        # Swing Techs
        [
          ["west", "ECT", 11, 8],
        ].each do |args|
          verify_shifts_contain(shifts[:swing][:techs], *args)
        end
        expect(shifts[:swing][:techs].length).to eq(1)

        # Swing RNs
        [
          ["goggin", "RN", 11, 12],
        ].each do |args|
          verify_shifts_contain(shifts[:swing][:rns], *args)
        end
        expect(shifts[:swing][:rns].length).to eq(1)

        # Night RNs
        [
          ["cordero", "RN", 19, 12],
          ["kostryba", "RN", 19, 12],
          ["williams", "RN", 19, 12],
          ["stachnik", "RN", 19, 12],
          ["abukhaled", "RN", 19, 12],
        ].each do |args|
          verify_shifts_contain(shifts[:night][:rns], *args)
        end
        expect(shifts[:night][:rns].length).to eq(5)

        # Night Techs
        [
          ["short", "ECT", 19, 12],
          ["coleman", "ECT", 19, 12],
        ].each do |args|
          verify_shifts_contain(shifts[:night][:techs], *args)
        end
        expect(shifts[:night][:techs].length).to eq(2)

        [
          ["godinez", "RN", 7, 12],
          ["simmons", "RN", 19, 12],
          ["cain", "ECT", 15, 8],
        ].each do |args|
          verify_shifts_contain(shifts[:unsorted], *args)
        end
        expect(shifts[:unsorted].length).to eq(3)
      end
    end

    it "includes orientees only in orientees section" do
      date = Date.new(2021,8,1)
      FactoryBot.create(:advocate_shift, date: date, raw_shift_code: "ORF", start: 7, duration: 12)
      FactoryBot.create(:advocate_shift, date: date, raw_shift_code: "ORF", start: 11, duration: 12)
      FactoryBot.create(:advocate_shift, date: date, raw_shift_code: "ORF", start: 19, duration: 12)

      presenter = SchedulePresenter.new(date, date + 30)
      shifts = presenter.shifts_for(date)

      expect(shifts[:day][:rns].length).to eq(0)
      expect(shifts[:swing][:rns].length).to eq(0)
      expect(shifts[:night][:rns].length).to eq(0)
      expect(shifts[:orientees].length).to eq(3)
    end
  end
end
