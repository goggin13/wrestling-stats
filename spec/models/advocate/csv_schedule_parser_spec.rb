require 'rails_helper'

module Advocate
  RSpec.describe CsvScheduleParser, type: :model do
    CSV_FILE_UNPRODUCTIVE_INCLUDED = <<-CSV
Emergency Department,09/06/2023,(F),"Shearod, Klinda",SIT,07-06,07:00,6.50
Emergency Department,09/06/2023,,"Edwards, Veronica",RN,07-08,07:00,8.50
Emergency Department,09/06/2023,(N),"Ahmad, Adam",RN,ORF,07:00,12.00
Emergency Department,09/06/2023,(N),"Hicks, Ciara",RN,ORF,07:00,12.00
Emergency Department,09/06/2023,(N),"Morrar, Khalid",RN,UNV,07:00,12.00
Emergency Department,09/06/2023,(N),"Rogers, Erica",ECT,ORF,07:00,12.00
Emergency Department,09/06/2023,,"Mccullough, Rebecca",LPN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"Arvesen, Abigail",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"Daniels, Michelle",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"hopkins, preciana",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"peluso riti, stephanie",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,,"Primeau, Libby",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"robin, joshua",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"Tolledo, Robert Patrick",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,(F),"Chavez, Yesenia",RN,CHGPREC,07:00,12.50
Emergency Department,09/06/2023,(N),"Maciha, Emma",RN,SWTCH,07:00,12.50
Emergency Department,09/06/2023,,"Foy, Tracey",ECT,07-12,07:00,12.50
Emergency Department,09/06/2023,,"Rivera, Amanda",ECT,07-12,07:00,12.50
Emergency Department,09/06/2023,,"Villa, Alma",ECT,07-12,07:00,12.50
Emergency Department,09/06/2023,,"Jaksich, Sandra",US,07-12,07:00,12.50
Emergency Department,09/06/2023,(N),"Duarte, Abigail",RN,CLEDP,08:00,7.00
Emergency Department,09/06/2023,,"Smith, Shannon",ECT,09-12,09:00,12.50
Emergency Department,09/06/2023,(F),"Barbosa, Mykaela",RN,EX11-08,11:00,8.50
Emergency Department,09/06/2023,,"Maciha, Emma",RN,EX11-08,11:00,8.50
Emergency Department,09/06/2023,,"West, Marguerite",ECT,EX11-08,11:00,8.50
Emergency Department,09/06/2023,,"Goggin, Matthew",RN,11-12,11:00,12.50
Emergency Department,09/06/2023,,"Gordon, Corrin",ACM,15-08,15:00,8.50
Emergency Department,09/06/2023,,"Sreepathy, Srjan",RN,PREC,15:00,12.50
Emergency Department,09/06/2023,(N),"Duarte, Abigail",RN,ORF,15:30,4.50
Emergency Department,09/06/2023,(N),"Hedenschoug, Tyler",RN,ORFNG,15:30,4.50
Emergency Department,09/06/2023,(F),"Turnbo, Tekilla",ECT,EX19-04,19:00,4.00
Emergency Department,09/06/2023,(N),"Hollins, Quentin",RN,ORF,19:00,12.00
Emergency Department,09/06/2023,(F),"cordero, kenneth",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"deere, katherine",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"hamka, nisreen",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"idemudia, egbenayaloben",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"Sosa, Sandra",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,,"Thornton, Steven",RN,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"Williams, Maria",RN,CHG1912,19:00,12.50
Emergency Department,09/06/2023,(F),"Simmons, Marquetta",RN,PREC,19:00,12.50
Emergency Department,09/06/2023,,"Curry, Jada",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"Nash, Anyzah",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,,"Parrow, Barbara",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,,"Short, Dawnn",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"Smith, Nicole",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,(F),"Vazquez, Ashley",ECT,19-12,19:00,12.50
Emergency Department,09/06/2023,,"Millsap, Cassandra",US,19-12,19:00,12.50
Emergency Department,09/06/2023,,"Conley, Kiesha",ACM,21-10,21:00,10.50

CSV

    CSV_FILE_WITH_TECHS = <<-CSV
Emergency Department,09/06/2023,,"Edwards, Veronica",RN,07-08,07:00,8.50
Department: 36102,09/06/2023,(F),"robin, joshua",RN,07-12,07:00,12.50
Emergency Department,09/06/2023,,"Foy, Tracey",ECT,07-12,07:00,12.50

CSV

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
      "morrar, khalid" => "FullTime",
      "ahmad, adam" => "FullTime",
      "hicks, ciara" => "FullTime",
      "duarte, abigail" => "FullTime",
      "hollins, quentin" => "FullTime",
      "foy, tracey" => "FullTime",
      "rogers, erica" => "unknown",
      "hedenschoug, tyler" => "FullTime",
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

    describe "techs" do
      it "parses techs" do
        File.write("tmp/shifts.csv", CSV_FILE_WITH_TECHS)
        CsvScheduleParser.parse("tmp/shifts.csv", "tmp/employees.yml")
        tracey = Advocate::Employee.where(name: "foy, tracey").first!
        expect(tracey.status).to eq("FullTime")
        expect(tracey.role).to eq("ECT")
      end
    end

    describe "Employee Types" do
      it "records employee types" do
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

    describe "parse_orientees" do
      it "parses out only orientees" do
        File.write("tmp/shifts.csv", CSV_FILE_UNPRODUCTIVE_INCLUDED)
        expect do
          expect do
            CsvScheduleParser.parse_orientees_from_nonproductive_file!(
              "tmp/shifts.csv",
              "tmp/employees.yml",
            )
          end.to change(Employee, :count).by(6)
        end.to change(Shift.where(raw_shift_code: "ORF"), :count).by(6)

        expect(Employee.where(name: "ahmad, adam").first).to be_present
        expect(Employee.where(name: "hicks, ciara").first).to be_present
        expect(Employee.where(name: "duarte, abigail").first).to be_present
        expect(Employee.where(name: "hollins, quentin").first).to be_present
        expect(Employee.where(name: "rogers, erica").first).to be_present
        expect(Employee.where(name: "hedenschoug, tyler").first).to be_present
      end

      it "parses does not create duplicate orientee shifts" do
        File.write("tmp/shifts.csv", CSV_FILE_UNPRODUCTIVE_INCLUDED)
        expect do
          expect do
            CsvScheduleParser.parse_orientees_from_nonproductive_file!(
              "tmp/shifts.csv",
              "tmp/employees.yml",
            )
            CsvScheduleParser.parse_orientees_from_nonproductive_file!(
              "tmp/shifts.csv",
              "tmp/employees.yml",
            )
          end.to change(Employee, :count).by(6)
        end.to change(Shift.where(raw_shift_code: "ORF"), :count).by(6)
      end
    end
  end
end
