/*
Nama	: Hilmi Fawwaz Sa'ad
NRP	: 5025221103
Kelas	: Sistem Basis Data (G)
Tugas	: Modul Pendahuluan 2
*/

-- NOMOR 1
# Membuaat Database Kedai Kopi Nuri
CREATE DATABASE kedaikopinuri_pendahuluan2

# Membuat Tabel Pegawai
CREATE TABLE Pegawai (
	NIK CHAR(16) NOT NULL PRIMARY KEY,
	Nama_pegawai VARCHAR(100),
	Jenis_kelamin CHAR(1),
	Email VARCHAR(50),
	Umur INT
);

# Membuat Tabel Telepon
CREATE TABLE Telepon (
	No_telp_pegawai VARCHAR(15) NOT NULL PRIMARY KEY,
	NIK CHAR(16),
	CONSTRAINT Telepon_Pegawai_FK FOREIGN KEY (NIK) REFERENCES Pegawai(NIK)
);

# Membuat Tabel Customer
CREATE TABLE Customer (
	ID_customer CHAR(6) NOT NULL PRIMARY KEY,
	Nama_customer VARCHAR(100)
);

# Membuat Tabel Menu_minuman
CREATE TABLE Menu_minuman (
	ID_minuman CHAR(6) NOT NULL PRIMARY KEY,
	Nama_minuman VARCHAR(50),
	Harga_minuman FLOAT(2)
);

# Membuat Tabel Transaksi
CREATE TABLE Transaksi (
	ID_transaksi CHAR(10) NOT NULL PRIMARY KEY,
	Tanggal_transaksi DATE,
	Metode_pembayaran VARCHAR(15),
	ID_customer CHAR(6),
	NIK CHAR(16),
	CONSTRAINT Transaksi_Customer_FK FOREIGN KEY (ID_customer) REFERENCES Customer(ID_customer),
	CONSTRAINT Transaksi_Pegawai_FK FOREIGN KEY (NIK) REFERENCES Pegawai(NIK)
);

# Membuat Tabel Transaksi_minuman
CREATE TABLE Transaksi_minuman (
	TM_Menu_minuman_ID CHAR(6),
	TM_Transaksi_ID CHAR(10), 
	Jumlah_cup INT,
	CONSTRAINT Transaksi_minuman_PK PRIMARY KEY (TM_Menu_minuman_ID, TM_Transaksi_ID),
	CONSTRAINT TM_ID_Menu_minuman_FK FOREIGN KEY (TM_Menu_minuman_ID) REFERENCES Menu_minuman(ID_minuman),
	CONSTRAINT TM_ID_Transaksi_FK FOREIGN KEY (TM_Transaksi_ID) REFERENCES Transaksi(ID_transaksi)
);


-- NOMOR 2
# Membuat Tabel Membership
CREATE TABLE Membership (
	ID_membership CHAR(6),
	No_telepon_customer VARCHAR(15),
	Alamat_customer VARCHAR(100),
	Tanggal_pembuatan_kartu_membership DATE,
	Tanggal_kadaluwarsa_kartu_membership DATE,
	Total_poin INT,
	ID_customer CHAR(6)
);

# A. Menjadikan ID_membership Primary Key
ALTER TABLE Membership ADD CONSTRAINT Membership_PK PRIMARY KEY (ID_membership);

# B. ID_customer sebagai Foreign Key dari Tabel Customer, bisa update, namun tidak bisa di delete ketika sudah jadi member
ALTER TABLE Membership
ADD CONSTRAINT Membership_Customer_FK FOREIGN KEY (ID_customer) REFERENCES Customer(ID_customer)
ON UPDATE CASCADE
ON DELETE RESTRICT;

# C. ID_customer dari tabel transaksi sebagai Foreign Key dan ON UPDATE CASCADE & ON DELETE CASCADE
ALTER TABLE Transaksi
DROP CONSTRAINT Transaksi_Customer_FK

ALTER TABLE Transaksi
ADD CONSTRAINT Transaksi_Customer_FK FOREIGN KEY (ID_customer) REFERENCES Customer(ID_customer)
ON UPDATE CASCADE
ON DELETE CASCADE;

# D. Nilai default tanggal_pembuatan_kartu_membership sebagai tanggal sekarang (trdpt fungsi build-in)
ALTER TABLE Membership
MODIFY Tanggal_pembuatan_kartu_membership DATE DEFAULT CURDATE();

# E. Constraint untuk melakukan pengecekan bahwa total_poin harus lebih dari atau sama dengan 0
ALTER TABLE Membership
ADD CONSTRAINT Cek_Total_poin CHECK (Total_poin >= 0);

# F. Ubah ukuran alamat maksimalnya menjadi 150
ALTER TABLE Membership
MODIFY Alamat_customer VARCHAR(150);


-- Nomor 3
# Menghapus Tabel Telepon dan menambahkan atribut telepon pada tabel pegawai
DROP TABLE Telepon

ALTER TABLE Pegawai
ADD Nomor_telepon VARCHAR(15);


-- Nomor 4
# Memasukkan data ke tabel customer
INSERT INTO Customer
VALUES
('CTR001', 'Budi Santoso'),
('CTR002', 'Sisil Triana'),
('CTR003', 'Davi Liam'),
('CTRo04', 'Sutris Ten An'),
('CTR005', 'Hendra Asto');

# Memasukkan data ke tabel membership
INSERT INTO membership
VALUES
('MBR001', '08123456789', 'Jl. Imam Bonjol', '2023-10-24', '2023-11-30', '0', 'CTR001'),
('MBR002', '0812345678', 'Jl. Kelinci', '2023-10-24', '2023-11-30', '3', 'CTR002'),
('MBR003', '081234567890', 'Jl. Abah Ojak', '2023-10-25', '2023-12-01', '2', 'CTR003'),
('MBR004', '08987654321', 'Jl. Kenangan', '2023-10-26', '2023-12-02', '6', 'CTR005');

# Memasukkan data ke tabel pegawai
INSERT INTO Pegawai
VALUES
('1234567890123456', 'Naufal Raf', 'L', 'nuafal@gmail.com', '19', '62123456789'),
('2345678901234561', 'Surinala', 'P', 'surinala@gmail.com', '24', '621234567890'),
('3456789012345612', 'Ben John', 'L', 'benjohn@gmail.com', '22', '6212345678');

# Memasukkan data ke tabel transaksi
INSERT INTO Transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, NIK, ID_customer)
VALUES
('TRX0000001', '2023-10-01', 'Kartu kredit', '2345678901234561', 'CTR002'),
('TRX0000002', '2023-10-03', 'Transfer bank', '3456789012345612', 'CTRo04'),
('TRX0000003', '2023-10-05', 'Tunai', '3456789012345612', 'CTR001'),
('TRX0000004', '2023-10-15', 'Kartu debit', '1234567890123456', 'CTR003'),
('TRX0000005', '2023-10-15', 'E-wallet', '1234567890123456', 'CTRo04'),
('TRX0000006', '2023-10-21', 'Tunai', '2345678901234561', 'CTR001');

# Memasukkan data ke tabel transaksi_menu / transaksi_minuman
INSERT INTO Transaksi_minuman (TM_Transaksi_ID, TM_Menu_minuman_ID, Jumlah_cup)
VALUES
('TRX0000005', 'MNM006', '2'),
('TRX0000001', 'MNM010', '1'),
('TRX0000002', 'MNM005', '1'),
('TRX0000005', 'MNM009', '1'),
('TRX0000003', 'MNM001', '3'),
('TRX0000006', 'MNM003', '2'),
('TRX0000004', 'MNM004', '2'),
('TRX0000004', 'MNM010', '1'),
('TRX0000002', 'MNM003', '2'),
('TRX0000001', 'MNM007', '1'),
('TRX0000005', 'MNM001', '1'),
('TRX0000003', 'MNM003', '1');

# Memasukkan data ke tabel menu
INSERT INTO Menu_minuman
VALUES
('MNM001', 'Expresso', '18000'),
('MNM002', 'Cappuccino', '20000'),
('MNM003', 'Latte', '21000'),
('MNM004', 'Americano', '19000'),
('MNM005', 'Mocha', '22000'),
('MNM006', 'Macchiato', '23000'),
('MNM007', 'Cold Brew', '21000'),
('MNM008', 'Iced Coffee', '18000'),
('MNM009', 'Affogato', '23000'),
('MNM010', 'Coffee Frappe', '22000');


-- Nomor 5
# Input pada transaksi, tanggal 3 okt 2023, ID pembeli CTRo04, transfer bank, 1 minuman jenis MNM005, pelayan Surinala
INSERT INTO Transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, NIK, ID_customer)
VALUES
('TRX0000007', '2023-10-03', 'Transfer bank', '2345678901234561', 'CTRo04');

INSERT INTO Transaksi_minuman
VALUES
('MNM005', 'TRX0000007', '1');


-- Nomor 6
# Tambah data pegawai dengan NIK 1111222233334444, nama Maimunah, umur 25
INSERT INTO Pegawai (NIK, Nama_pegawai, Umur)
VALUES
('1111222233334444', 'Maimunah', '25');


-- Nomor 7
# Mengupdate ID dari CTRo04 menjadi CTR004
UPDATE Customer
SET ID_customer = 'CTR004'
WHERE ID_customer = 'CTRo04'


-- Nomor 8
# Update Maimunah itu perempuan, no telp 621234567, dan email maimunah@gmail.com
UPDATE Pegawai
SET Jenis_kelamin = 'P', Nomor_telepon = '621234567', Email = 'maimunah@gmail.com'
WHERE NIK = '1111222233334444';


-- Nomor 9
# Reset total_poin menjadi 0 ketika awal bulan dan update semua total poin dari membership dengan tanggal_kedaluarsa sebelum bulan desember
UPDATE Membership
SET Total_poin = 0
WHERE DATE_FORMAT(NOW(), '%Y-%m-01') = '2023-12-01';

UPDATE Membership
SET Total_poin = 0
WHERE DATE_FORMAT(Tanggal_kadaluwarsa_kartu_membership, '%Y-%m-01') < '2023-12-01';


-- Nomor 10
# Menghapus semua data membership
DELETE FROM Membership


-- Nomor 11
# Hapus data pegawai dengan nama Maimunah
DELETE FROM Pegawai WHERE Nama_pegawai = 'Maimunah'