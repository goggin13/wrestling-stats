require 'rails_helper'

module Advocate
  RSpec.describe Shift, type: :model do
    before do
      @employee = FactoryBot.create(:advocate_employee)
    end

    describe "create_from_raw_shift_code" do
      it "creates a new shift" do
        date = Date.new(2023, 3, 19)
        shift = Shift.create_from_raw_shift_code("07-12", date, @employee)
        expect(shift.id).to be_present
        expect(shift.raw_shift_code).to eq("07-12")
        expect(shift.employee_id).to eq(@employee.id)
        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(12)
        expect(shift.date).to eq(date)
      end

      it "modifies an existing shift" do
        date = Date.new(2023, 3, 19)
        shift = FactoryBot.create(:advocate_shift,
                          start: 7, duration: 12, date: date,
                          employee: @employee)
        expect do
          Shift.create_from_raw_shift_code("07-08", date, @employee)
        end.to change(Shift, :count).by(0)

        shift.reload

        expect(shift.raw_shift_code).to eq("07-08")
        expect(shift.employee_id).to eq(@employee.id)
        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(8)
        expect(shift.date).to eq(date)
      end
    end

    describe "parse_shift_code!" do
      it "parses 07-12" do
        shift = Shift.new(raw_shift_code: "07-12")
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(12)
      end

      it "parses EX0708" do
        shift = Shift.new(raw_shift_code: "EX0708")
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(8)
      end

      it "parses EX07-08" do
        shift = Shift.new(raw_shift_code: "EX07-08")
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(8)
      end

      it "parses OC07-12" do
        shift = Shift.new(raw_shift_code: "OC07-12")
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(12)
      end

      it "parses CHG1912" do
        shift = Shift.new(raw_shift_code: "CHG1912")
        shift.parse_shift_code!

        expect(shift.start).to eq(19)
        expect(shift.duration).to eq(12)
      end

      it "parses emma as a preceptor 7-12" do
        employee = FactoryBot.create(:advocate_employee, first: "Emma")
        shift = Shift.new(raw_shift_code: "[PREC]", employee: employee)
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(12)
      end

      it "parses yazen as a charge 19-12" do
        employee = FactoryBot.create(:advocate_employee, first: "Yazen")
        shift = Shift.new(raw_shift_code: "[CHG]", employee: employee)
        shift.parse_shift_code!

        expect(shift.start).to eq(19)
        expect(shift.duration).to eq(12)
      end

      it "parses Kal as a charge 19-12" do
        employee = FactoryBot.create(:advocate_employee, first: "Khalid")
        shift = Shift.new(raw_shift_code: "[$CHG]", employee: employee)
        shift.parse_shift_code!

        expect(shift.start).to eq(7)
        expect(shift.duration).to eq(12)
      end

      it "parses Erin as a triage 19-12" do
        employee = FactoryBot.create(:advocate_employee, first: "Erin")
        shift = Shift.new(raw_shift_code: "[TRIAGE]", employee: employee)
        shift.parse_shift_code!

        expect(shift.start).to eq(19)
        expect(shift.duration).to eq(12)
      end
    end
  end

  describe "working_during?" do
    describe "day" do
      before do
        @shift = Shift.new(start: 7, duration: 12)
      end

      it "is true for the start of a day shift" do
        expect(@shift.working_during?(7)).to eq(true)
      end

      it "is true for the middle of a day shift" do
        expect(@shift.working_during?(10)).to eq(true)
      end

      it "is false for the end of a day shift" do
        expect(@shift.working_during?(19)).to eq(false)
      end

      it "is false for before the shift starts" do
        expect(@shift.working_during?(5)).to eq(false)
      end

      it "is false for after the shift ends" do
        expect(@shift.working_during?(23)).to eq(false)
      end
    end

    describe "night" do
      before do
        @shift = Shift.new(start: 19, duration: 12)
      end

      it "is true for the start of a night shift" do
        expect(@shift.working_during?(19)).to eq(true)
      end

      it "is true for the middle of a night shift" do
        expect(@shift.working_during?(23)).to eq(true)
      end

      it "is true for the middle of a night shift after midnight" do
        expect(@shift.working_during?(6)).to eq(true)
      end

      it "is false for the end of a night shift" do
        expect(@shift.working_during?(7)).to eq(false)
      end

      it "is false for before the shift starts" do
        expect(@shift.working_during?(18)).to eq(false)
      end

      it "is false for after the shift ends" do
        expect(@shift.working_during?(8)).to eq(false)
      end
    end
  end
end
