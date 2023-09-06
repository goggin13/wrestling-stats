require 'rails_helper'

module Advocate
  RSpec.describe CsvScheduleParser, type: :model do
    CSV_FILE_SHORT = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50

CSV

    CSV_FILE_LPN = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/30/2023,,"Berrios, Maricela",LPN,19-12,19:00,12.50

CSV

    CSV_FILE_MIXED = <<-CSV
textbox175,textbox3,textbox9,EmployeeName,textbox15,textbox2,CalendarDate,textbox1
Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
Department: 36102,08/30/2023,(F),"Godinez, Donna",RN,07-12,07:00,12.50
Department: 36102,08/30/2023,(F),"robin, joshua",RN,07-12,07:00,12.50

CSV

    EMPLOYEE_FILE = {
      "berrios, maricela" => "Agency",
      "edwards, veronica" => "FullTime",
      "godinez, donna" => "Unknown",
      "robin, joshua" => "Agency",
    }.to_yaml

    before do
      File.write("tmp/shifts.csv", CSV_FILE_SHORT)
      File.write("tmp/employees.yml", EMPLOYEE_FILE)
    end

    it "creates an employee" do
      expect do
        CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
      end.to change(Employee, :count).by(1)

      employee = Employee.last!
      expect(employee.name).to eq("edwards, veronica")
      expect(employee.first).to eq("veronica")
      expect(employee.last).to eq("edwards")
      expect(employee.role).to eq("RN")
    end

    it "creates a shift" do
      expect do
        CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
      end.to change(Shift, :count).by(1)

      employee = Employee.last!
      shift = Shift.last
      expect(shift.date).to eq(Date.new(2023, 8, 30))
      expect(shift.start).to eq(7)
      expect(shift.duration).to eq(8)
      expect(shift.raw_shift_code).to eq("CHGPREC")
      expect(shift.employee_id).to eq(employee.id)
    end

    it "deletes previous shifts from the time period" do
      CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
      expect do
        CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
      end.to change(Shift, :count).by(0)
    end

    it "does not delete shifts from other time frames" do
      before_shift = FactoryBot.create(:advocate_shift,
                                       date: Date.new(2023, 8, 29),
                                       start: 7,
                                       duration: 12)
      after_shift = FactoryBot.create(:advocate_shift,
                                       date: Date.new(2023, 8, 31),
                                       start: 7,
                                       duration: 12)

      CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")

      expect(Advocate::Shift.find(before_shift.id)).to be_present
      expect(Advocate::Shift.find(after_shift.id)).to be_present
    end

    it "adds a new employee for a new role" do
      employee = FactoryBot.create(:advocate_employee,
                                   name: "edwards, veronica",
                                   first: "veronica",
                                   last: "edwards",
                                   role: "ECT")

      CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")

      veronicas = Advocate::Employee.where(
        name: "edwards, veronica",
        first: "veronica",
        last: "edwards"
      ).all

      expect(veronicas.map(&:role).sort).to eq(["ECT", "RN"])
    end

    it "counts an LPN as an RN" do
      File.write("tmp/shifts.csv", CSV_FILE_LPN)
      CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")

      employee = Employee.last!
      expect(employee.role).to eq("RN")
    end

    describe "Employee Types" do
      it "works" do
        File.write("tmp/shifts.csv", CSV_FILE_MIXED)
        CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
        veronica = Advocate::Employee.where(name: "edwards, veronica").first!
        expect(veronica.status).to eq("FullTime")

        josh = Advocate::Employee.where(name: "robin, joshua").first!
        expect(josh.status).to eq("Agency")

        donna = Advocate::Employee.where(name: "godinez, donna").first
        expect(donna.status).to eq("Unknown")
      end
    end
  end
end
