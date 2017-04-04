class Doctor
  attr_reader(:name, :id, :specialty_id)
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
  end

  define_singleton_method(:all) do
    returned_doctors = DB.exec("SELECT * FROM doctor;")
    doctors = []
    returned_doctors.each() do |doctor|
      name = doctor.fetch('name')
      specialty_id = doctor.fetch('specialty_id')
      id = doctor.fetch('id').to_i()
      doctors.push(Doctor.new({:name => name, :id => id, :specialty_id => specialty_id}))
    end
    doctors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO doctor (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i()
  end

  define_method(:==) do |another_doctor|
    self.name == another_doctor.name && self.id == another_doctor.id
  end

  define_singleton_method(:find) do |targetid|
    found_doctor = nil
    Doctor.all().each() do |doctor|
      if doctor.id == targetid
        found_doctor = doctor
      end
    end
    found_doctor
  end

  define_method(:patients) do
    doctor_patients = []
    patients = DB.exec("SELECT * FROM patient WHERE doctor_id = #{self.id()};")
    patients.each() do |patient|
      name = patient.fetch('name')
      birthdate = patient.fetch('birthdate')
      doctor_id = patient.fetch('doctor_id').to_i()
      doctor_patients.push(Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id}))
    end
    doctor_patients
  end

end
