# doctor-office
This program is for office administrators to track patients in a doctor's office.

Database setup instructions: 
CREATE DATABASE doctors;
  CREATE TABLE doctor (id serial PRIMARY KEY, name varchar, patient_id int);
  CREATE TABLE patient (id serial PRIMARY KEY, name varchar, birthdate date);
  CREATE TABLE specialty (id serial PRIMARY KEY, name varchar, doctor_id int);
