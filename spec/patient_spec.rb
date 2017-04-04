require('rspec')
require('pg')
require('patient')

DB = PG.connect({:dbname => 'doctor_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM patient *;")
  end
end

describe(Patient) do
  describe('.all') do
    it('starts off with no patients') do
      expect(Patient.all()).to(eq([]))
    end
  end

  describe("#name") do
    it('gives patient name') do
      test_patient = Patient.new({:name => "kevin", :birthdate => "1993-10-30", :doctor_id => 1})
      expect(test_patient.name()).to(eq('kevin'))
    end
  end

  describe("#save") do
    it("returns an array of patients when saved") do
      test_patient = Patient.new({:name => 'kevin', :birthdate => "1993-10-30", :doctor_id => 1})
      test_patient.save()
      expect(Patient.all()).to(eq([test_patient]))
    end
  end

  describe("#==") do
    it("is the same patient if they have the same name, birthdate and Id") do
      patient1 = Patient.new({:name => 'kevin', :birthdate => "1993-10-30", :doctor_id => 1})
      patient2 = Patient.new({:name => 'kevin', :birthdate => "1993-10-30", :doctor_id => 1})
      expect(patient1).to(eq(patient2))
    end
  end


end
