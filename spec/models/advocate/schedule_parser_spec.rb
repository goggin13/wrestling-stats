require 'rails_helper'

module Advocate
  RSpec.describe ScheduleParser, type: :model do
    before do
      @file = "spec/download_fixtures/advocate/schedule.html"
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
      end.to change(Shift, :count).by 682

      shift = Shift.first!
      expect(shift.employee.name).to eq("Abukhaled, Yazen")
      expect(shift.raw_shift_code).to eq("19-12")
      expect(shift.date).to eq(DateTime.parse("3/21"))
    end

  end
end
