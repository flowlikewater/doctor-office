require('rspec')
require('pg')
require('doctor')
require('patient')

DB = PG.connect({:dbname => 'doctor_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM doctor *;")
  end
end

describe(Doctor) do
  describe(".all") do
    it("starts off with no doctors") do
      expect(Doctor.all()).to(eq([]))
    end
  end

  describe('#name') do
    it("returns the name of a doctor") do
      test_doctor = Doctor.new(:name => 'pace', :specialty_id => 1)
      expect(test_doctor.name).to(eq('pace'))
    end
  end

  describe("#save") do
    it("returns an array of doctors") do
      test_doctor = Doctor.new(:name => 'pace', :specialty_id => 1)
      test_doctor.save()
      expect(Doctor.all()).to(eq([test_doctor]))
    end
  end

  describe('#==') do
    it('is the same doctor if they have the same name and id') do
      test_doctor = Doctor.new(:name => 'pace', :specialty_id => 1)
      test_doctor2 = Doctor.new(:name => 'pace', :specialty_id => 1)
      expect(test_doctor).to(eq(test_doctor2))
    end
  end

  describe(".find") do
    it('returns the doctor with a given id') do
      test_doctor = Doctor.new(:name => 'pace', :specialty_id => 1)
      test_doctor.save()
      expect(Doctor.find(test_doctor.id())).to(eq(test_doctor))
    end
  end

  describe("#patients") do
    it('returns a list of patients for a specific doctor') do
      test_doctor = Doctor.new(:name => 'pace', :specialty_id => 1)
      test_doctor.save()
      test_patient = Patient.new({:name => "kevin", :birthdate => "1993-10-30", :doctor_id => test_doctor.id()})
      test_patient.save()
      test_patient2 = Patient.new({:name => "pace", :birthdate => "1991-10-20", :doctor_id => test_doctor.id()})
      test_patient2.save()
      expect(test_doctor.patients()).to(eq([test_patient, test_patient2]))
    end
  end



end
