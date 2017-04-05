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

get('/specialty/:id/:doctorid') do
  @specialty_id = params.fetch("id").to_i()
  @doctor_id = params.fetch("doctorid").to_i
  @selected_doctor = Doctor.find(@doctor_id)
  @patients = @selected_doctor.patients()
  erb(:doctor)
end

post('/specialty/:id/:doctorid') do
  @specialty_id = params.fetch("id").to_i()
  @doctor_id = params.fetch("doctorid").to_i
  name = params.fetch('name')
  birthdate = params.fetch('birthdate')
  new_patient = Patient.new({:name => name, :birthdate => birthdate, :doctor_id => @doctor_id})
  new_patient.save()
  @selected_doctor = Doctor.find(@doctor_id)
  @patients = @selected_doctor.patients()
  erb(:doctor)
end
