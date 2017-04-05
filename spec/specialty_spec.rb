require('rspec')
require('pg')
require('doctor')
require('patient')
require('specialty')

DB = PG.connect({:dbname => 'doctor_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM specialty *;")
  end
end

describe(Specialty) do
  describe(".all") do
    it('starts off as an empty array') do
      expect(Specialty.all()).to(eq([]))
    end
  end

  describe("#name") do
    it('returns name of object') do
      test_specialty = Specialty.new(:name => 'chiro')
      expect(test_specialty.name()).to(eq('chiro'))
    end
  end

  describe("#save") do
    it('able to find the object through id') do
      test_specialty = Specialty.new(:name => 'chiro')
      test_specialty.save()
      expect(Specialty.all()).to(eq([test_specialty]))
    end
  end

  describe("#doctors") do
    it('returns a list of doctors for a specific specialty') do
      test_specialty = Specialty.new(:name => 'chiro')
      test_specialty.save()
      test_doctor = Doctor.new(:name => 'Apple', :specialty_id => test_specialty.id())
      test_doctor.save()
      test_doctor2 = Doctor.new(:name => 'Bananas', :specialty_id => test_specialty.id())
      test_doctor2.save()
      expect(test_specialty.doctors()).to(eq([test_doctor, test_doctor2]))
    end
  end

  describe(".find") do
    it('find a specialty by his id') do
      test_specialty = Specialty.new(:name => 'chiro')
      test_specialty.save()
      test_specialty2 = Specialty.new(:name => 'physio')
      test_specialty2.save()
      expect(Specialty.find(test_specialty2.id)).to(eq(test_specialty2))
    end
  end


end
