require 'rails_helper'

module Advocate
  RSpec.describe StaffingCalculator, type: :model do
    # Sample Data from 3/21
    # 0700-0900: rn: 5, tech: 6
    # 0900-1100: rn: 6, tech: 6
    # 1100-1500: rn: 7, tech: 7
    # 1500-1900: rn: 10, tech: 6
    # 1900-2300: rn: 8, tech: 4
    # 2300-0300: rn: 7, tech: 3
    # 0300-0700: rn: 5, tech: 3

    describe "counts" do
      before do
        @file = "spec/download_fixtures/advocate/schedule_2023-03-19#2023-04-15.html"
        ScheduleParser.parse!(@file)
      end

      it "returns a hash of hours => % staffed for RNs and Techs" do
        result = StaffingCalculator.new(Date.new(2023, 3, 21)).counts

        expect(result[7]).to eq({ rns: 5, techs: 6, rn_pct: 71.43 })
        expect(result[9]).to eq({ rns: 6, techs: 6, rn_pct: 75 })
        expect(result[11]).to eq({ rns: 7, techs: 7, rn_pct: 70 })
        expect(result[15]).to eq({ rns: 10, techs: 6, rn_pct: 100 })
        expect(result[19]).to eq({ rns: 8, techs: 4, rn_pct: 80 })
        expect(result[23]).to eq({ rns: 7, techs: 3, rn_pct: 77.78 })
        expect(result[3]).to eq({ rns: 5, techs: 3, rn_pct: 62.5 })
      end
    end

    describe "write_records" do
      it "writes StaffingHour records" do
        expect do
          StaffingCalculator.new(Date.new(2023, 3, 21)).write_records
        end.to change(StaffingHour, :count).by 24

        {
          7 => { rns: 5, techs: 6, rn_pct: 71.43 },
          9 => { rns: 6, techs: 6, rn_pct: 75 },
          11 => { rns: 7, techs: 7, rn_pct: 70 },
          15 => { rns: 10, techs: 6, rn_pct: 100 },
          19 => { rns: 8, techs: 4, rn_pct: 80 },
          23 => { rns: 7, techs: 3, rn_pct: 77.78 },
          3 => { rns: 5, techs: 3, rn_pct: 62.5 }
        }.each do |hour, results|
          StaffingHour.where(
            date: Date.new(2023, 3, 21),
            hour: hour,
            rns: results[:rns],
            rn_pct: results[:rn_pct],
            techs: results[:techs]
          )
        end
      end
    end
  end
end
