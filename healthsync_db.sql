-- =======================================================
-- HỆ THỐNG HEALTHSYNC - TÁI CẤU TRÚC CSDL
-- Tác giả: Học viên CodeGym
-- =======================================================

-- 1. TẠO DATABASE VÀ SỬ DỤNG
CREATE DATABASE IF NOT EXISTS healthsync_db;
USE healthsync_db;

-- 2. TẠO LẠI CÁC BẢNG (DROP ĐỂ LÀM SẠCH DỮ LIỆU CŨ)
DROP TABLE IF EXISTS Prescriptions;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Patients;

-- Bảng Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- Bảng Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- Bảng Appointments (Đã sửa đổi theo đúng nghiệp vụ)
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME NOT NULL,
    
    -- Thay thế is_active bằng status ENUM
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    
    -- Bổ sung các trường tài chính và lý do hủy
    deposit_amount DECIMAL(10, 2) DEFAULT 0.00,
    penalty_fee DECIMAL(10, 2) DEFAULT 0.00,
    cancel_reason VARCHAR(255),
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Bảng Prescriptions (Mới thêm vào để lưu đơn thuốc)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT UNIQUE NOT NULL, -- Quan hệ 1-1 với Appointments
    medication_details TEXT,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- =======================================================
-- 3. MÔ PHỎNG KỊCH BẢN NGHIỆP VỤ (DML)
-- =======================================================

-- Thêm dữ liệu mẫu cho Bệnh nhân và Bác sĩ
INSERT INTO Patients (full_name, phone) VALUES ('Nguyen Van A', '0901234567');
INSERT INTO Patients (full_name, phone) VALUES ('Tran Thi B', '0912345678');
INSERT INTO Doctors (full_name, specialty) VALUES ('Dr. Le Van C', 'Noi khoa');

-- KỊCH BẢN 1: THÀNH CÔNG (Đặt lịch -> Khám -> Kê đơn)
-- 1.1. Bệnh nhân A đặt lịch, trạng thái PENDING, cọc 500k
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount) 
VALUES (1, 1, '2026-10-01 08:00:00', 'PENDING', 500000.00);

-- 1.2. Bệnh nhân đến, chuyển trạng thái CHECKED_IN
UPDATE Appointments SET status = 'CHECKED_IN' WHERE appointment_id = 1;

-- 1.3. Khám xong, chuyển trạng thái COMPLETED
UPDATE Appointments SET status = 'COMPLETED' WHERE appointment_id = 1;

-- 1.4. Bác sĩ kê đơn thuốc cho lịch hẹn này
INSERT INTO Prescriptions (appointment_id, medication_details) 
VALUES (1, 'Paracetamol 500mg, uống 2 lần/ngày');

-- KỊCH BẢN 2: HỦY VÀ PHẠT (Đặt lịch -> Xác nhận -> Hủy)
-- 2.1. Bệnh nhân B đặt lịch, trạng thái CONFIRMED, cọc 300k
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount) 
VALUES (2, 1, '2026-10-02 09:00:00', 'CONFIRMED', 300000.00);

-- 2.2. Bệnh nhân hủy lịch, ghi nhận lý do và phạt 150k
UPDATE Appointments 
SET status = 'CANCELLED', 
    cancel_reason = 'Bận việc đột xuất', 
    penalty_fee = 150000.00 
WHERE appointment_id = 2;

-- =======================================================
-- 4. TRUY VẤN KIỂM TRA (SELECT)
-- =======================================================

-- Truy vấn 1: Kiểm tra trạng thái và dòng tiền của tất cả lịch hẹn
SELECT 
    a.appointment_id, 
    p.full_name AS patient_name, 
    a.status, 
    a.deposit_amount, 
    a.penalty_fee, 
    a.cancel_reason
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id;

-- Truy vấn 2: Lấy danh sách bệnh nhân đã khám xong và đơn thuốc của họ
SELECT 
    p.full_name AS patient_name,
    a.appointment_date,
    pr.medication_details,
    pr.issued_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';