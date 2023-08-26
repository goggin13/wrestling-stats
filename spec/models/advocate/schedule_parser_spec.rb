require 'rails_helper'

module Advocate
  RSpec.describe ScheduleParser, type: :model do
    before do
      @file = "spec/download_fixtures/advocate/schedule_2023-03-19#2023-04-15.html"
    end

    it "writes the employees to the employees table" do
      expect do
        ScheduleParser.parse!(@file)
      end.to change(Employee, :count).by 125

      employee = Employee.first!
      expect(employee.name).to eq("Abukhaled, Yazen")
      expect(employee.first).to eq("Yazen")
      expect(employee.last).to eq("Abukhaled")
      expect(employee.role).to eq("RN")

      employee = Employee.last(2)[0]
      expect(employee.name).to eq("Yancey, Charnita")
      expect(employee.first).to eq("Charnita")
      expect(employee.last).to eq("Yancey")
      expect(employee.role).to eq("NCT")
    end

    it "writes the shifts to the shifts table" do
      expect do
        ScheduleParser.parse!(@file)
      end.to change(Shift, :count).by 514

      shift = Shift.first!
      expect(shift.employee.name).to eq("Abukhaled, Yazen")
      expect(shift.raw_shift_code).to eq("19-12")
      expect(shift.date).to eq(DateTime.parse("3/21"))
    end

    it "ignores TDs with [ALTERNATE] in the title" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-08-20#2023-09-16.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Reyes").first!
      expect(employee.shifts.count).to eq(4)
    end

    it "ignores PTO" do
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Conley").first!
      expect(employee.shifts.where(date: Date.new(2023, 4, 3)).count).to eq(0)
    end

    it "ignores CLED" do
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Cervantes").first!
      expect(employee.shifts.where(date: Date.new(2023, 3, 28)).count).to eq(0)
    end

    it "ignores UNV" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-01-08#2023-02-04.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Hall").first!
      expect(employee.shifts.where(date: Date.new(2023, 1, 23)).count).to eq(0)
    end

    it "ignores ABS" do
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Foy").first!
      expect(employee.shifts.where(date: Date.new(2023, 3, 23)).count).to eq(0)
    end

    it "ignores BEREV" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-01-08#2023-02-04.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Harden").first!
      expect(employee.shifts.where(date: Date.new(2023, 1, 17)).count).to eq(0)
    end

    it "ignores SWTCH" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-01-08#2023-02-04.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(first: "Yazen").first!
      expect(employee.shifts.where(date: Date.new(2023, 1, 10)).count).to eq(0)
    end

    it "ignores SICK" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-01-08#2023-02-04.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Cedeno").first!
      expect(employee.shifts.where(date: Date.new(2023, 1, 18)).count).to eq(0)
    end

    it "includes swing shift agency" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2023-08-20#2023-09-16.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Devine").first!
      expect(employee.shifts.count).to eq(12)
    end

    it "deletes existing shifts from this time frame" do
      employee = FactoryBot.create(:advocate_employee,
                                   first: "Matt", last: "Goggin", role: "RN")
      shift = FactoryBot.create(:advocate_shift,
                                employee: employee,
                                date: Date.parse("19-03-2023"),
                                start: 7,
                                duration: 12)

      ScheduleParser.parse!(@file)

      expect(Advocate::Shift.where(id: shift.id).first).to be_nil
    end

    it "does not delete shifts from other time frames" do
      employee = FactoryBot.create(:advocate_employee,
                                   first: "Matt", last: "Goggin", role: "RN")
      shift_before = FactoryBot.create(:advocate_shift,
                                       employee: employee,
                                       date: Date.parse("18-03-2023"),
                                       start: 7, duration: 12)
      shift_after = FactoryBot.create(:advocate_shift,
                                       employee: employee,
                                       date: Date.parse("16-04-2023"),
                                       start: 7, duration: 12)

      ScheduleParser.parse!(@file)

      expect(Advocate::Shift.find(shift_before.id)).to be_present
      expect(Advocate::Shift.find(shift_after.id)).to be_present
    end

    it "handles dates across a year boundary" do
      @file = "spec/download_fixtures/advocate/archive/schedule_2022-12-11#2023-01-07.html"
      ScheduleParser.parse!(@file)

      employee = Employee.where(last: "Goggin").first!
      expect(employee.shifts.first.date).to eq(Date.parse("15/12/2022"))
      expect(employee.shifts.last.date).to eq(Date.parse("07/01/2023"))
    end
  end
end
