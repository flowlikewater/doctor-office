require('pry')

class Specialty
  attr_reader(:name, :id)
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes[:id]
  end

  define_singleton_method(:all) do
    returned_specialties = DB.exec("SELECT * FROM specialty;")
    specialties = []
    returned_specialties.each() do |specialty|
      name = specialty.fetch('name')
      id = specialty.fetch('id').to_i()
      specialties.push(Specialty.new({:name => name, :id => id}))
    end
    specialties
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO specialty (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  define_method(:==) do |another_specialty|
    self.name == another_specialty.name && self.id == another_specialty.id
  end

  define_method(:doctors) do
    specialty_doctors = []
    doctors = DB.exec("SELECT * FROM doctor WHERE specialty_id= #{@id};")
    doctors.each() do |doctor|
      name = doctor.fetch('name')
      id = doctor.fetch('id').to_i()
      specialty_id = doctor.fetch('specialty_id').to_i()
      specialty_doctors.push(Doctor.new({:name => name, :id => id, :specialty_id => specialty_id}))
    end
    specialty_doctors
  end

  define_singleton_method(:find) do |findid|
    chosen_specialty = nil
    specialties = DB.exec("SELECT * FROM specialty")
    specialties.each() do |specialty|
      name = specialty.fetch('name')
      id = specialty.fetch('id').to_i()
      if id == findid
        chosen_specialty = Specialty.new({:name => name, :id => id})
      end
    end
    chosen_specialty
  end

end
