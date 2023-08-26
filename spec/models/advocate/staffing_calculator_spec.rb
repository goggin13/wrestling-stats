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

        expect(result["0700"]).to eq({ rns: 5, techs: 6, rn_pct: 71.43 })
        expect(result["0900"]).to eq({ rns: 6, techs: 6, rn_pct: 75 })
        expect(result["1100"]).to eq({ rns: 7, techs: 7, rn_pct: 70 })
        expect(result["1500"]).to eq({ rns: 10, techs: 6, rn_pct: 100 })
        expect(result["1900"]).to eq({ rns: 8, techs: 4, rn_pct: 80 })
        expect(result["2300"]).to eq({ rns: 7, techs: 3, rn_pct: 77.78 })
        expect(result["0300"]).to eq({ rns: 5, techs: 3, rn_pct: 62.5 })
      end
    end
  end
end
