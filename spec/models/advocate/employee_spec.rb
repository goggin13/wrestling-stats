require 'rails_helper'

module Advocate
  RSpec.describe Employee, type: :model do
    describe "create_from_full_name" do
      it "creates an employee after splitting up the name" do
        employee = Employee.create_from_full_name("Goggin, Matthew", "RN")
        expect(employee.id).to be_present
        expect(employee.name).to eq("Goggin, Matthew")
        expect(employee.first).to eq("Matthew")
        expect(employee.last).to eq("Goggin")
        expect(employee.role).to eq("RN")
      end

      it "capitalizes a lowercased name" do
        employee = Employee.create_from_full_name("goggin, matthew", "RN")
        expect(employee.first).to eq("Matthew")
        expect(employee.last).to eq("Goggin")
      end

      it "preserves a hyphen" do
        employee = Employee.create_from_full_name("Jane-John, Matthew", "RN")
        expect(employee.first).to eq("Matthew")
        expect(employee.last).to eq("Jane-john")
      end
    end

    describe "update_shift_label" do
      before do
        @employee = Employee.create_from_full_name("Goggin, Matthew", "RN")
      end

      it "assigns DAY to a day shifter" do
        FactoryBot.create(:advocate_shift,
                          start: 7, duration: 12, employee: @employee)

        @employee.update_shift_label!
        @employee.reload
        expect(@employee.shift_label).to eq("DAY")
      end

      it "assigns SWING to a swing shifter" do
        FactoryBot.create(:advocate_shift,
                          start: 11, duration: 12, employee: @employee)

        @employee.update_shift_label!
        @employee.reload
        expect(@employee.shift_label).to eq("SWING")
      end

      it "assigns NIGHT to a night shifter" do
        FactoryBot.create(:advocate_shift,
                          start: 19, duration: 12, employee: @employee)

        @employee.update_shift_label!
        @employee.reload
        expect(@employee.shift_label).to eq("NIGHT")
      end

      it "assigns NIGHT to a 23 start time" do
        FactoryBot.create(:advocate_shift,
                          start: 23, duration: 12, employee: @employee)

        @employee.update_shift_label!
        @employee.reload
        expect(@employee.shift_label).to eq("NIGHT")
      end

      it "choose the shift type with the most shifts" do
        FactoryBot.create(:advocate_shift,
                          start: 7, duration: 12, employee: @employee)
        FactoryBot.create(:advocate_shift,
                          start: 19, duration: 12, employee: @employee)
        FactoryBot.create(:advocate_shift,
                          start: 19, duration: 12, employee: @employee)

        @employee.update_shift_label!
        @employee.reload
        expect(@employee.shift_label).to eq("NIGHT")
      end
    end
  end
end
