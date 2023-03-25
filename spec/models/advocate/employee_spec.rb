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
  end
end
