require('sinatra')
require('sinatra/reloader')
require('./lib/specialty')
require('./lib/doctor')
require('./lib/patient')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "doctor_test"})

get('/') do
  @specialties = Specialty.all()
  erb(:index)
end

get('/add_specialty') do
  erb(:add_specialty)
end

post('/') do
  @name = params.fetch('name')
  newspec = Specialty.new({:name => @name})
  newspec.save()
  @specialties = Specialty.all()
  erb(:index)
end

get('/specialty/:id') do
  @specialty = Specialty.find(params.fetch("id").to_i())
  @doctors = @specialty.doctors()
  erb(:specialty)
end

post('/specialty/:id') do
  @specialty = Specialty.find(params.fetch("id").to_i())
  name = params.fetch('name')
  specialty_id = @specialty.id().to_i()
  new_doctor = Doctor.new(:name => name, :specialty_id => specialty_id)
  new_doctor.save()
  @doctors = @specialty.doctors()
  erb(:specialty)
end
