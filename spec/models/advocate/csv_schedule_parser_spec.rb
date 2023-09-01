require 'rails_helper'

module Advocate
  RSpec.describe CsvScheduleParser, type: :model do
    CSV_FILE_SHORT = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50

CSV

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

    before do
    end

    it "creates an employee" do
      File.write("tmp/shifts.csv", CSV_FILE_SHORT)
      expect do
        CsvScheduleParser.parse("tmp/shifts.csv")
      end.to change(Employee, :count).by(1)

      employee = Employee.last!
      expect(employee.name).to eq("Edwards, Veronica")
      expect(employee.first).to eq("Veronica")
      expect(employee.last).to eq("Edwards")
      expect(employee.role).to eq("RN")
    end

    it "creates a shift" do
      File.write("tmp/shifts.csv", CSV_FILE_SHORT)
      expect do
        CsvScheduleParser.parse("tmp/shifts.csv")
      end.to change(Shift, :count).by(1)

      employee = Employee.last!
      shift = Shift.last
      expect(shift.date).to eq(Date.new(2023, 8, 30))
      expect(shift.start).to eq(7)
      expect(shift.duration).to eq(8)
      expect(shift.raw_shift_code).to eq("CHGPREC")
      expect(shift.employee_id).to eq(employee.id)
    end
  end
end
