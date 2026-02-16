-- ============================================
-- TP2: Hospital Management System
-- ============================================

DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;


-- Table: specialties
CREATE TABLE specialties (
    specialty_id INT PRIMARY KEY AUTO_INCREMENT,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    consultation_fee DECIMAL(10, 2) NOT NULL
);

-- Table: doctors
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialty_id INT NOT NULL,
    license_number VARCHAR(20) UNIQUE NOT NULL,
    hire_date DATE,
    office VARCHAR(100),
    active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (specialty_id) REFERENCES specialties(specialty_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table: patients
CREATE TABLE patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    file_number VARCHAR(20) UNIQUE NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    blood_type VARCHAR(5),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    province VARCHAR(50),
    registration_date DATE DEFAULT (CURRENT_DATE),
    insurance VARCHAR(100),
    insurance_number VARCHAR(50),
    allergies TEXT,
    medical_history TEXT
);

-- Table: consultations
CREATE TABLE consultations (
    consultation_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    diagnosis TEXT,
    observations TEXT,
    blood_pressure VARCHAR(20),
    temperature DECIMAL(4, 2),
    weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    status ENUM('Scheduled', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    amount DECIMAL(10, 2),
    paid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: medications
CREATE TABLE medications (
    medication_id INT PRIMARY KEY AUTO_INCREMENT,
    medication_code VARCHAR(20) UNIQUE NOT NULL,
    commercial_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    form VARCHAR(50),
    dosage VARCHAR(50),
    manufacturer VARCHAR(100),
    unit_price DECIMAL(10, 2) NOT NULL,
    available_stock INT DEFAULT 0,
    minimum_stock INT DEFAULT 10,
    expiration_date DATE,
    prescription_required BOOLEAN DEFAULT TRUE,
    reimbursable BOOLEAN DEFAULT FALSE
);

-- Table: prescriptions
CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY AUTO_INCREMENT,
    consultation_id INT NOT NULL,
    prescription_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    treatment_duration INT,
    general_instructions TEXT,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: prescription_details
CREATE TABLE prescription_details (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions VARCHAR(200) NOT NULL,
    duration INT NOT NULL,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescription_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (medication_id) REFERENCES medications(medication_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Indexes
CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_consultation_date ON consultations(consultation_date);
CREATE INDEX idx_consultation_patient ON consultations(patient_id);
CREATE INDEX idx_consultation_doctor ON consultations(doctor_id);
CREATE INDEX idx_medication_name ON medications(commercial_name);
CREATE INDEX idx_prescription_consultation ON prescriptions(consultation_id);

-- Test Data

-- Specialties
INSERT INTO specialties (specialty_name, description, consultation_fee) VALUES
('General Medicine', 'Primary healthcare', 1500.00),
('Cardiology', 'Heart and blood vessels', 3000.00),
('Pediatrics', 'Medical care of infants and children', 2000.00),
('Dermatology', 'Skin, hair, and nails', 2500.00),
('Orthopedics', 'Musculoskeletal system', 2800.00),
('Gynecology', 'Female reproductive system', 2500.00);

-- Doctors
INSERT INTO doctors (last_name, first_name, email, phone, specialty_id, license_number, hire_date, office, active) VALUES
('House', 'Gregory', 'house@hospital.com', '555-0101', 1, 'LIC001', '2010-05-12', 'Office 101', TRUE),
('Shepherd', 'Derek', 'shepherd@hospital.com', '555-0102', 2, 'LIC002', '2012-08-20', 'Office 202', TRUE),
('Grey', 'Meredith', 'grey@hospital.com', '555-0103', 3, 'LIC003', '2015-03-15', 'Office 303', TRUE),
('Wilson', 'James', 'wilson@hospital.com', '555-0104', 4, 'LIC004', '2011-11-10', 'Office 404', TRUE),
('Torres', 'Callie', 'torres@hospital.com', '555-0105', 5, 'LIC005', '2014-06-25', 'Office 505', TRUE),
('Montgomery', 'Addison', 'montgomery@hospital.com', '555-0106', 6, 'LIC006', '2013-01-30', 'Office 606', TRUE);

-- Patients
INSERT INTO patients (file_number, last_name, first_name, date_of_birth, gender, blood_type, email, phone, address, city, province, registration_date, insurance, insurance_number, allergies, medical_history) VALUES
('PAT001', 'Smith', 'John', '1985-04-10', 'M', 'A+', 'john.smith@email.com', '0661223344', '123 Rue de la Paix', 'Algiers', 'Algiers', '2024-01-15', 'CNAS', '123456789', 'Penicillin', 'Hypertension'),
('PAT002', 'Doe', 'Jane', '2015-08-22', 'F', 'O-', 'jane.doe@email.com', '0550112233', '456 Avenue des Roses', 'Oran', 'Oran', '2024-02-10', 'None', NULL, 'Peanuts', 'Asthma'),
('PAT003', 'Brown', 'Charlie', '1950-11-30', 'M', 'B+', 'charlie.brown@email.com', '0770445566', '789 Boulevard Central', 'Constantine', 'Constantine', '2023-11-05', 'CASNOS', '987654321', 'None', 'Diabetes Type 2'),
('PAT004', 'Wilson', 'Sarah', '1992-02-14', 'F', 'AB+', 'sarah.wilson@email.com', '0662334455', '321 Rue de l''Espoir', 'Annaba', 'Annaba', '2024-05-20', 'CNAS', '456123789', 'Dust', 'None'),
('PAT005', 'Taylor', 'Michael', '2010-06-05', 'M', 'A-', 'michael.taylor@email.com', '0551223344', '654 Rue du Commerce', 'Setif', 'Setif', '2024-06-12', 'None', NULL, 'None', 'None'),
('PAT006', 'Miller', 'Emily', '1978-12-25', 'F', 'O+', 'emily.miller@email.com', '0771556677', '987 Rue de la Liberté', 'Tlemcen', 'Tlemcen', '2024-03-01', 'CNAS', '789456123', 'Latex', 'Migraines'),
('PAT007', 'Davis', 'Robert', '1965-09-18', 'M', 'B-', 'robert.davis@email.com', '0663445566', '159 Rue des Oliviers', 'Bejaia', 'Bejaia', '2024-07-10', 'CASNOS', '321654987', 'None', 'Arthritis'),
('PAT008', 'White', 'Sophia', '2020-01-10', 'F', 'A+', 'sophia.white@email.com', '0552334455', '753 Rue du Soleil', 'Batna', 'Batna', '2024-08-05', 'None', NULL, 'None', 'None');

-- Consultations
INSERT INTO consultations (patient_id, doctor_id, consultation_date, reason, diagnosis, observations, blood_pressure, temperature, weight, height, status, amount, paid) VALUES
(1, 1, '2025-01-10 09:00:00', 'Routine checkup', 'Healthy', 'Patient feels good', '120/80', 36.6, 75.0, 180.0, 'Completed', 1500.00, TRUE),
(2, 3, '2025-01-12 10:30:00', 'Fever and cough', 'Common cold', 'Prescribed rest', '110/70', 38.5, 25.0, 120.0, 'Completed', 2000.00, TRUE),
(3, 2, '2025-01-15 14:00:00', 'Chest pain', 'Angina', 'Needs further tests', '140/90', 36.8, 85.0, 175.0, 'Completed', 3000.00, FALSE),
(4, 4, '2025-01-18 11:00:00', 'Skin rash', 'Eczema', 'Allergic reaction', '115/75', 36.5, 60.0, 165.0, 'Completed', 2500.00, TRUE),
(5, 3, '2025-01-20 09:30:00', 'Vaccination', 'N/A', 'Booster shot', '105/65', 36.7, 35.0, 145.0, 'Completed', 2000.00, TRUE),
(6, 5, '2025-02-01 15:00:00', 'Knee pain', 'Ligament strain', 'Physical therapy recommended', '125/85', 36.6, 68.0, 170.0, 'Completed', 2800.00, TRUE),
(7, 6, '2025-02-05 10:00:00', 'Annual exam', 'Healthy', 'No issues', '130/85', 36.5, 80.0, 178.0, 'Scheduled', 2500.00, FALSE),
(8, 3, '2025-02-10 11:30:00', 'Ear infection', 'Otitis media', 'Antibiotics prescribed', '100/60', 37.8, 12.0, 85.0, 'Completed', 2000.00, TRUE);

-- Medications
INSERT INTO medications (medication_code, commercial_name, generic_name, form, dosage, manufacturer, unit_price, available_stock, minimum_stock, expiration_date, prescription_required, reimbursable) VALUES
('MED001', 'Doliprane', 'Paracetamol', 'Tablet', '1000mg', 'Sanofi', 250.00, 100, 20, '2026-12-31', FALSE, TRUE),
('MED002', 'Amoxil', 'Amoxicillin', 'Capsule', '500mg', 'GSK', 450.00, 50, 15, '2025-06-30', TRUE, TRUE),
('MED003', 'Lipitor', 'Atorvastatin', 'Tablet', '20mg', 'Pfizer', 1200.00, 30, 10, '2026-03-15', TRUE, TRUE),
('MED004', 'Ventolin', 'Salbutamol', 'Inhaler', '100mcg', 'GSK', 850.00, 20, 5, '2025-09-20', TRUE, TRUE),
('MED005', 'Zyrtec', 'Cetirizine', 'Tablet', '10mg', 'UCB', 350.00, 40, 10, '2026-01-10', FALSE, FALSE),
('MED006', 'Voltaren', 'Diclofenac', 'Gel', '1%', 'Novartis', 600.00, 25, 8, '2025-11-30', FALSE, TRUE),
('MED007', 'Augmentin', 'Amoxicillin/Clavulanate', 'Tablet', '1g', 'GSK', 950.00, 15, 10, '2025-04-15', TRUE, TRUE),
('MED008', 'Gaviscon', 'Sodium Alginate', 'Syrup', '250ml', 'Reckitt', 400.00, 60, 15, '2026-05-20', FALSE, FALSE),
('MED009', 'Glucophage', 'Metformin', 'Tablet', '850mg', 'Merck', 300.00, 80, 20, '2027-02-28', TRUE, TRUE),
('MED010', 'Advil', 'Ibuprofen', 'Tablet', '400mg', 'Pfizer', 200.00, 5, 15, '2025-08-15', FALSE, FALSE);

-- Prescriptions
INSERT INTO prescriptions (consultation_id, treatment_duration, general_instructions) VALUES
(2, 7, 'Take after meals'),
(3, 30, 'Take every morning'),
(4, 5, 'Apply twice daily'),
(5, 1, 'Single dose'),
(6, 14, 'Apply gel and rest'),
(8, 10, 'Complete the full course'),
(2, 5, 'Drink plenty of fluids');

-- Prescription Details
INSERT INTO prescription_details (prescription_id, medication_id, quantity, dosage_instructions, duration, total_price) VALUES
(1, 1, 2, '1 tablet 3 times a day', 7, 500.00),
(1, 2, 1, '1 capsule twice a day', 7, 450.00),
(2, 3, 1, '1 tablet daily', 30, 1200.00),
(3, 5, 1, '1 tablet at night', 5, 350.00),
(4, 1, 1, 'As needed', 1, 250.00),
(5, 6, 1, 'Apply to knee', 14, 600.00),
(6, 7, 2, '1 tablet twice a day', 10, 1900.00),
(6, 1, 1, 'For pain', 5, 250.00),
(7, 8, 1, '10ml after meals', 5, 400.00),
(1, 10, 1, 'For fever', 3, 200.00),
(2, 9, 2, '1 tablet twice a day', 30, 600.00),
(3, 4, 1, '2 puffs as needed', 30, 850.00);

-- SQL Queries (30)

-- ========== PART 1: BASIC QUERIES (Q1-Q5) ==========

-- Q1. List all patients with their main information
SELECT file_number, CONCAT(last_name, ' ', first_name) AS full_name, date_of_birth, phone, city FROM patients;

-- Q2. Display all doctors with their specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, d.office, d.active 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id;

-- Q3. Find all medications with price less than 500 DA
SELECT medication_code, commercial_name, unit_price, available_stock FROM medications WHERE unit_price < 500;

-- Q4. List consultations from January 2025
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.status 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.consultation_date BETWEEN '2025-01-01' AND '2025-01-31 23:59:59';

-- Q5. Display medications where stock is below minimum stock
SELECT commercial_name, available_stock, minimum_stock, (minimum_stock - available_stock) AS difference 
FROM medications 
WHERE available_stock < minimum_stock;


-- ========== PART 2: QUERIES WITH JOINS (Q6-Q10) ==========

-- Q6. Display all consultations with patient and doctor names
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, c.diagnosis, c.amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id;

-- Q7. List all prescriptions with medication details
SELECT pr.prescription_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, m.commercial_name AS medication_name, pd.quantity, pd.dosage_instructions 
FROM prescription_details pd 
JOIN prescriptions pr ON pd.prescription_id = pr.prescription_id 
JOIN consultations c ON pr.consultation_id = c.consultation_id 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN medications m ON pd.medication_id = m.medication_id;

-- Q8. Display patients with their last consultation date
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, MAX(c.consultation_date) AS last_consultation_date, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
GROUP BY p.patient_id, p.last_name, p.first_name, d.last_name, d.first_name;

-- Q9. List doctors and the number of consultations performed
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q10. Display revenue by medical specialty
SELECT s.specialty_name, SUM(c.amount) AS total_revenue, COUNT(c.consultation_id) AS consultation_count 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name;


-- ========== PART 3: AGGREGATE FUNCTIONS (Q11-Q15) ==========

-- Q11. Calculate total prescription amount per patient
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, SUM(pd.total_price) AS total_prescription_cost 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
JOIN prescription_details pd ON pr.prescription_id = pd.prescription_id 
GROUP BY p.patient_id, p.last_name, p.first_name;

-- Q12. Count the number of consultations per doctor
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
LEFT JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q13. Calculate total stock value of pharmacy
SELECT COUNT(medication_id) AS total_medications, SUM(unit_price * available_stock) AS total_stock_value FROM medications;

-- Q14. Find average consultation price per specialty
SELECT s.specialty_name, AVG(c.amount) AS average_price 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name;

-- Q15. Count number of patients by blood type
SELECT blood_type, COUNT(patient_id) AS patient_count FROM patients GROUP BY blood_type;


-- ========== PART 4: ADVANCED QUERIES (Q16-Q20) ==========

-- Q16. Find the top 5 most prescribed medications
SELECT m.commercial_name AS medication_name, COUNT(pd.detail_id) AS times_prescribed, SUM(pd.quantity) AS total_quantity 
FROM medications m 
JOIN prescription_details pd ON m.medication_id = pd.medication_id 
GROUP BY m.medication_id, m.commercial_name 
ORDER BY times_prescribed DESC 
LIMIT 5;

-- Q17. List patients who have never had a consultation
SELECT CONCAT(last_name, ' ', first_name) AS patient_name, registration_date 
FROM patients 
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM consultations);

-- Q18. Display doctors who performed more than 2 consultations
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name AS specialty, COUNT(c.consultation_id) AS consultation_count 
FROM doctors d 
JOIN specialties s ON d.specialty_id = s.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY d.doctor_id, d.last_name, d.first_name, s.specialty_name 
HAVING COUNT(c.consultation_id) > 2;

-- Q19. Find unpaid consultations with total amount
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.consultation_date, c.amount, CONCAT(d.last_name, ' ', d.first_name) AS doctor_name 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
JOIN doctors d ON c.doctor_id = d.doctor_id 
WHERE c.paid = FALSE;

-- Q20. List medications expiring in less than 6 months from today
SELECT commercial_name, expiration_date, DATEDIFF(expiration_date, CURRENT_DATE) AS days_until_expiration 
FROM medications 
WHERE expiration_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 6 MONTH);


-- ========== PART 5: SUBQUERIES (Q21-Q25) ==========

-- Q21. Find patients who consulted more than the average
SELECT patient_name, consultation_count, average_count
FROM (
    SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, COUNT(c.consultation_id) AS consultation_count
    FROM patients p
    JOIN consultations c ON p.patient_id = c.patient_id
    GROUP BY p.patient_id, p.last_name, p.first_name
) AS patient_counts,
(
    SELECT AVG(cnt) AS average_count
    FROM (SELECT COUNT(consultation_id) AS cnt FROM consultations GROUP BY patient_id) AS counts
) AS avg_table
WHERE consultation_count > average_count;

-- Q22. List medications more expensive than average price
SELECT commercial_name, unit_price, (SELECT AVG(unit_price) FROM medications) AS average_price 
FROM medications 
WHERE unit_price > (SELECT AVG(unit_price) FROM medications);

-- Q23. Display doctors from the most requested specialty
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, s.specialty_name, specialty_counts.cnt AS specialty_consultation_count
FROM doctors d
JOIN specialties s ON d.specialty_id = s.specialty_id
JOIN (
    SELECT s.specialty_id, COUNT(c.consultation_id) AS cnt
    FROM specialties s
    JOIN doctors d ON s.specialty_id = d.specialty_id
    JOIN consultations c ON d.doctor_id = c.doctor_id
    GROUP BY s.specialty_id
) AS specialty_counts ON s.specialty_id = specialty_counts.specialty_id
WHERE specialty_counts.cnt = (
    SELECT MAX(cnt) FROM (
        SELECT COUNT(c.consultation_id) AS cnt
        FROM specialties s
        JOIN doctors d ON s.specialty_id = d.specialty_id
        JOIN consultations c ON d.doctor_id = c.doctor_id
        GROUP BY s.specialty_id
    ) AS max_counts
);

-- Q24. Find consultations with amount higher than average
SELECT c.consultation_date, CONCAT(p.last_name, ' ', p.first_name) AS patient_name, c.amount, (SELECT AVG(amount) FROM consultations) AS average_amount 
FROM consultations c 
JOIN patients p ON c.patient_id = p.patient_id 
WHERE c.amount > (SELECT AVG(amount) FROM consultations);

-- Q25. List allergic patients who received a prescription
SELECT CONCAT(p.last_name, ' ', p.first_name) AS patient_name, p.allergies, COUNT(pr.prescription_id) AS prescription_count 
FROM patients p 
JOIN consultations c ON p.patient_id = c.patient_id 
JOIN prescriptions pr ON c.consultation_id = pr.consultation_id 
WHERE p.allergies IS NOT NULL AND p.allergies != 'None' 
GROUP BY p.patient_id, p.last_name, p.first_name, p.allergies;


-- ========== PART 6: BUSINESS ANALYSIS (Q26-Q30) ==========

-- Q26. Calculate total revenue per doctor (paid consultations only)
SELECT CONCAT(d.last_name, ' ', d.first_name) AS doctor_name, COUNT(c.consultation_id) AS total_consultations, SUM(c.amount) AS total_revenue 
FROM doctors d 
JOIN consultations c ON d.doctor_id = c.doctor_id 
WHERE c.paid = TRUE 
GROUP BY d.doctor_id, d.last_name, d.first_name;

-- Q27. Display top 3 most profitable specialties
SELECT RANK() OVER (ORDER BY SUM(c.amount) DESC) AS `rank`, s.specialty_name, SUM(c.amount) AS total_revenue 
FROM specialties s 
JOIN doctors d ON s.specialty_id = d.specialty_id 
JOIN consultations c ON d.doctor_id = c.doctor_id 
GROUP BY s.specialty_id, s.specialty_name 
LIMIT 3;

-- Q28. List medications to restock (stock < minimum)
SELECT commercial_name, available_stock AS current_stock, minimum_stock, (minimum_stock - available_stock) AS quantity_needed 
FROM medications 
WHERE available_stock < minimum_stock;

-- Q29. Calculate average number of medications per prescription
SELECT AVG(med_count) AS average_medications_per_prescription 
FROM (
    SELECT COUNT(detail_id) AS med_count 
    FROM prescription_details 
    GROUP BY prescription_id
) AS counts;

-- Q30. Generate patient demographics report by age group
SELECT 
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 0 AND 18 THEN '0-18'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 19 AND 40 THEN '19-40'
        WHEN TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group,
    COUNT(patient_id) AS patient_count,
    (COUNT(patient_id) / (SELECT COUNT(*) FROM patients)) * 100 AS percentage
FROM patients
GROUP BY age_group;
