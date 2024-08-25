/*https://www.freecodecamp.org/learn/relational-database/build-a-salon-appointment-scheduler-project/build-a-salon-appointment-scheduler*/

CREATE DATABASE salon;

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL 
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  time VARCHAR(50) NOT NULL,
  customer_id INT NOT NULL,
  service_id INT NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id)
);

INSERT INTO services(name) 
VALUES ('cut'),('color'),('perm'),('style'),('trim'),('wash');