require 'rails_helper'

module Advocate
  RSpec.describe SchedulePresenter, type: :model do

    def verify_shifts_contain(shifts, last, role, start, duration, raw_shift_code=nil)
      matches = shifts.select do |shift|
        success = shift.employee.last == last &&
          shift.employee.role == role &&
          shift.start == start &&
          shift.duration == duration

        if raw_shift_code
          success = success && shift.raw_shift_code == raw_shift_code
        end

        success
      end

      expect(matches.length).to eq(1)
    end

    def verify_shift(shift, last, role, start, duration)
      verify_shifts_contain([shift], last, role, start, duration)
    end

    before do
      @file = "spec/download_fixtures/advocate/schedule.html"
      ScheduleParser.parse!(@file)
    end

    it "returns information for a day sorted by shifts and jobs" do
      presenter = SchedulePresenter.new
      day = presenter.shifts_for("3/19")
      expect(day[:day][:us].employee.name).to eq("Owens, Adrienne")
      expect(day[:day][:us].employee.role).to eq("US")
    end

    it "passes an integration spec" do
      presenter = SchedulePresenter.new
      shifts = presenter.shifts_for("3/21")


      # Day US + RNs
      verify_shift(shifts[:day][:us], "Jaksich", "US", 7, 12)
      expect(shifts[:day][:rns].length).to eq(7)
      [
        ["Cattenhead", "RN", 7, 12],
        ["Daniels", "RN", 7, 12],
        ["Edwards", "RN", 7, 12],
        ["Jones", "RN", 7, 12],
        ["Morrar", "RN", 7, 12],
        ["Taylor", "AGCY", 7, 12],
        ["Soto", "RN", 9, 10],
      ].each do |args|
        verify_shifts_contain(shifts[:day][:rns], *args)
      end

      # Day TECHs
      expect(shifts[:day][:techs].length).to eq(6)
      [
        ["Akwei", "NCT", 7, 8],
        ["Losias", "NCT", 7, 12],
        ["Plunkett", "TECH", 7, 12],
        ["Rivera", "TECH", 7, 12],
        ["Valdez", "TECH", 7, 12],
        ["Villa", "TECH", 7, 12],
      ].each do |args|
        verify_shifts_contain(shifts[:day][:techs], *args)
      end

      # Swing RNs
      expect(shifts[:swing][:rns].length).to eq(4)
      [
        ["Hall", "AGCY", 15, 12],
        ["Sreepathy", "RN", 15, 12],
        ["Teresi", "RN", 11, 8],
        ["Noreen", "RN", 15, 8],
      ].each do |args|
        verify_shifts_contain(shifts[:swing][:rns], *args)
      end

      # Swing TECHs
      expect(shifts[:swing][:techs].length).to eq(1)
      verify_shifts_contain(shifts[:swing][:techs], "Smith", "TECH", 11, 12)

      # Night US + RNs
      verify_shift(shifts[:night][:us], "Washington", "US", 19, 12)
      expect(shifts[:night][:rns].length).to eq(10)
      [
        ["Abukhaled", "RN", 19, 12],
        ["Adekunle", "RN", 19, 12],
        ["Berrios", "LPN", 19, 12],
        ["Stachnik", "RN", 19, 12],
        ["Escobar", "AGCY", 19, 12],
        ["Hopkins", "AGCY", 19, 12],
        ["Mingo", "RN", 19, 12],
        ["Nevins", "AGCY", 19, 12],
        ["Reyes", "RN", 19, 12],
        ["Thornton", "RN", 19, 12],
      ].each do |args|
        verify_shifts_contain(shifts[:night][:rns], *args)
      end

      # Night TECHs
      expect(shifts[:night][:techs].length).to eq(4)
      [
        ["Barney", "NCT", 19, 12],
        ["Johnson", "TECH", 19, 12],
        ["Yancey", "NCT", 19, 12],
        ["Coleman", "TECH", 19, 12],
      ].each do |args|
        verify_shifts_contain(shifts[:night][:techs], *args)
      end

      # Unsorted
      expect(shifts[:unsorted].length).to eq(5)
      [
        ["Goggin", "RN", nil, nil, "[ORF]"],
        ["Forrest-clark", "NCT", nil, nil, "[$]"],
        ["Mitchell", "RN", nil, nil, "[$]"],
        ["Jackson", "TECH", nil, nil, "[ORF]"],
        ["Williams", "RN", nil, nil, "[ORF]"],
      ].each do |args|
        verify_shifts_contain(shifts[:unsorted], *args)
      end
    end
#
#
# Other


# Day 3/21
# Sandy 07-12
# Cattenhead 07-12
# Michelle D 07-12
# Edwards V 07-12
# Jones 0712
# Morrar 0712
# Soto 09-10
# Taylor 07-12

# Akwei 07-08 NCT
# Losias 0712
# Plunkett 0712
# Rivera 0712
# Valdez 07-12
# Villa 07-12
#
#
# Swing
# Hall, Annalise 15-12
# Noreen OC15-08
# Sreepathy 15-12
# Teresi 11-08
#
# Smith 11-12
#
# Night
# US Washington 19-12
# Yazen 19-12
# Suliat 19-12
# Berrios 19-12 LPN
# Stachnik 19-12
# Escobar 19-12
# Hopkins 19-12
# Mingo 19-12
# Nevins 19-12
# Reyes 19-12
# Thornton 19-12
#
# Barney 19-12 (NCT)
# Leslie 19-12
# Johnson 19-12
# Yancey 19-12
  end
end