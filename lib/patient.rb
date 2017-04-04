class Patient
  attr_reader(:name, :birthdate, :doctor_id)
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @birthdate = attributes.fetch(:birthdate)
    @doctor_id = attributes[:doctor_id]
  end

  define_singleton_method(:all) do
    returned_patients = DB.exec('select * from patient;')
    patients = []
    returned_patients.each() do |patient|
      name = patient.fetch('name')
      birthdate = patient.fetch('birthdate')
      doctor_id = patient.fetch('doctor_id').to_i
      patients.push(Patient.new({:name => name, :birthdate => birthdate, :doctor_id => doctor_id}))
    end
    patients
  end

  define_method(:save) do
    DB.exec("INSERT INTO patient (name, birthdate, doctor_id) VALUES ('#{@name}', '#{@birthdate}', #{@doctor_id});")
  end

  define_method(:==) do |another_patient|
    self.name() == another_patient.name() && self.birthdate() == another_patient.birthdate() && self.doctor_id() == another_patient.doctor_id()
  end

end
