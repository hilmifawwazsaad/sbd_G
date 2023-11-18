# 1
-- membuat database
CREATE DATABASE Rental_Film_Beta

-- membuat tabel akses
CREATE TABLE akses (
	ak_id CHAR (6) NOT NULL PRIMARY KEY,
	ak_jenis_akses VARCHAR (100) NOT NULL
);

-- membuat tabel kategori
CREATE TABLE kategori (
	k_id CHAR (6) NOT NULL PRIMARY KEY,
	k_jenis_kategori VARCHAR (50) NOT NULL
);

-- membuat tabel customer
CREATE TABLE customer (
	cs_nik CHAR (16) NOT NULL PRIMARY KEY,
	cs_nama VARCHAR (100) NOT NULL,
	cs_email VARCHAR (100) NOT NULL,
	cs_alamat VARCHAR (100) NOT NULL,
	cs_usia INTEGER NOT NULL,
	cs_jenis_kelamin CHAR (1) NOT NULL
);

-- membuat tabel no_telp
CREATE TABLE no_telp (
	no_nomor_telepon VARCHAR (15) NOT NULL PRIMARY KEY,
	customer_cs_nik CHAR (16) NOT NULL,
	CONSTRAINT no_telp_customer_FK FOREIGN KEY (customer_cs_nik) REFERENCES customer (cs_nik)
);

-- membuat tabel pegawai
CREATE TABLE pegawai (
	pe_nip CHAR (10) NOT NULL PRIMARY KEY,
	pe_nama VARCHAR (100) NOT NULL,
	pe_no_telp VARCHAR (15) NOT NULL,
	pe_email VARCHAR (100) NOT NULL,
	pe_alamat VARCHAR (100) NOT NULL,
	pe_jenis_kelamin CHAR (1) NOT NULL,
	pe_usia INTEGER NOT NULL,
	akses_ak_id CHAR (6) NOT NULL,
	CONSTRAINT pegawai_akses_FK FOREIGN KEY (akses_ak_id) REFERENCES akses (ak_id)
);

-- membuat tabel film
CREATE TABLE film (
	f_id CHAR (6) NOT NULL PRIMARY KEY,
	f_judul VARCHAR (50) NOT NULL,
	f_rumah_produksi VARCHAR (50) NOT NULL,
	f_stok INTEGER NOT NULL,
	f_tahun_rilis INTEGER NOT NULL,
	f_durasi INTEGER NOT NULL, 
	kategori_k_id CHAR (6) NOT NULL,
	CONSTRAINT film_kategori_FK FOREIGN KEY (kategori_k_id) REFERENCES kategori (k_id)
);

-- membuat tabel transaksi_rental_film
CREATE TABLE transaksi_rental_film (
	trf_id CHAR (10) NOT NULL PRIMARY KEY,
	trf_tgl_rental DATE NOT NULL,
	trf_tgl_kembali DATE NOT NULL,
	trf_denda DECIMAL (10,2),
	pegawai_pe_nip CHAR (10) NOT NULL,
	customer_cs_nik CHAR (16) NOT NULL,
	CONSTRAINT transaksi_rental_film_pegawai_FK FOREIGN KEY (pegawai_pe_nip) REFERENCES pegawai (pe_nip),
	CONSTRAINT transaksi_rental_film_customer_FK FOREIGN KEY (customer_cs_nik) REFERENCES customer (cs_nik)
);

-- membuat tabel rental_film
CREATE TABLE rental_film (
	film_f_id CHAR (6) NOT NULL,
	transaksi_rental_film_trf_id CHAR (10) NOT NULL,
	CONSTRAINT rental_film_PK PRIMARY KEY (film_f_id, transaksi_rental_film_trf_id),
	CONSTRAINT rental_film_film_FK FOREIGN KEY (film_f_id) REFERENCES film (f_id),
	CONSTRAINT rental_film_transaksi_rental_film_FK FOREIGN KEY (transaksi_rental_film_trf_id) REFERENCES transaksi_rental_film (trf_id)
);

# 2
-- membuat tabel sutradara
CREATE TABLE sutradara (
	st_id CHAR (7) NOT NULL PRIMARY KEY,
	st_nama VARCHAR (40) NOT NULL,
	st_reputasi DECIMAL (5,2)
);

-- kolom baru pada tabel film
ALTER TABLE film
ADD sutradara_st_id CHAR (7) NOT NULL;

ALTER TABLE film
ADD CONSTRAINT film_sutradara_st_id FOREIGN KEY (sutradara_st_id) REFERENCES sutradara (st_id);

# 3
-- membuat tabel pekerjaan
CREATE TABLE pekerjaan (
	pk_id INTEGER NOT NULL PRIMARY KEY,
	pk_pekerjaan VARCHAR (25) NOT NULL
);

-- membuat kolom sekaligus foreign key
ALTER TABLE pegawai
ADD pekerjaan_pk_id INTEGER NOT NULL;

ALTER TABLE pegawai
ADD CONSTRAINT pegawai_pekerjaan_FK FOREIGN KEY (pekerjaan_pk_id) REFERENCES pekerjaan (pk_id);

# 4
-- menambah atribut baru pe_jabatan
ALTER TABLE pegawai
ADD pe_jabatan VARCHAR (40) NOT NULL;

-- menghapus tabel pekerjaan, hapus dulu foreign key dan hapus colom
ALTER TABLE pegawai
DROP CONSTRAINT pegawai_pekerjaan_fk;

ALTER TABLE pegawai
DROP COLUMN pekerjaan_pk_id;

DROP TABLE pekerjaan

# 5
-- isi data customer
INSERT INTO customer
VALUES
('CUST000000000001', 'Glenn Tripet', 'gtripet0@patch.com', '46603 Boyd Street', 18, 'F'),
('CUST000000000002', 'Fawn Senescall', 'fsenescall@spiegel.de', '132 Anderson Way', 54, 'F'),
('CUST000000000003',  'Ab Gladstone', 'agladstone2@mayoclinic.com', '57 North Trail', 21, 'M'),
('CUST000000000004', 'Peadar Dyson', 'pdyson3@newyorker.com', '8 Summerview Circle', 33, 'M');

-- isi data no_telp
INSERT INTO no_telp
VALUES
('628729155673914', 'CUST000000000001'),
('628454187815572', 'CUST000000000002'),
('628803804248717', 'CUST000000000003'),
('628015403301463', 'CUST000000000004');

-- isi data kategori
INSERT INTO kategori
VALUES
('K00001', 'Romance'),
('K00002', 'Romcom'),
('K00003', 'Comedy'),
('K00004', 'Thriller'),
('K00005', 'Horror');

-- isi data akses
INSERT INTO akses
VALUES
('AK0001', 'staff'),
('AK0002', 'intern'),
('AK0003', 'admin');

-- isi data sutradara
INSERT INTO sutradara
VALUES 
('ST00001', 'Marga Eggerton', 96.06),
('ST00002', 'Demetria Genese', 84.66),
('ST00003', 'Cory Greenroa', 10.59),
('ST00004', 'Daveen Freestone', 42.32);

-- isi data pegawai 
INSERT INTO pegawai
VALUES
('PE00000001', 'Jay Jordine', '628173677924604', 'jjordine0@slideshare.net', '6158 International Park', 'F', 39, 'AK0002', 'intern'),
('PE00000002', 'Ange Monkhouse', '628934810980689', 'amonkhouse1@sohu.com', '9 Macphersonn Road', 'F', 30, 'AK0001', 'staff');

-- isi data film 
INSERT INTO film
VALUES
('F00001', 'Gangster', 'Aksa Bumi Langit', 191, 1994, 147, 'K00001', 'ST00001'),
('F00002', 'Gantian Dong', 'Aneka Cahaya Nusantara', 52, 2012, 169, 'K00002', 'ST00002'),
('F00003', 'Gara-gara', 'Butik Innovasi Maleo', 148, 2008, 159, 'K00003', 'ST00004'),
('F00004', 'Gara-gara Bola', 'Dapurfilm Production', 14, 1986, 114, 'K00004', 'ST00003'),
('F00005', 'Gara-gara Djanda Muda', 'Forka Sejahtera Nusantara', 156, 2002, 175, 'K00005', 'ST00002');

-- isi data transaksi_rental_film
INSERT INTO transaksi_rental_film
VALUES
('TRF0000001', '2023-03-02', '2023-03-13', NULL, 'PE00000001', 'CUST000000000001'),
('TRF0000002', '2023-03-11', '2023-03-20', NULL, 'PE00000002', 'CUST000000000002'),
('TRF0000003', '2023-04-01', '2023-04-28', 70000.00, 'PE00000001', 'CUST000000000003'),
('TRF0000004', '2023-04-29', '2023-05-05', 10000.00, 'PE00000001', 'CUST000000000004');

-- isi data rental_film
INSERT INTO rental_film
VALUES
('F00001', 'TRF0000001'),
('F00003', 'TRF0000001'),
('F00001', 'TRF0000002'),
('F00004', 'TRF0000003'),
('F00005', 'TRF0000004');

# 6 
-- Mengubah tipe data id pada kategori menjadi int, ubah dahulu tabel yang ada foreign key-nya
ALTER TABLE film
DROP CONSTRAINT film_kategori_FK;

ALTER TABLE kategori
MODIFY COLUMN k_id INT AUTO_INCREMENT;

ALTER TABLE film 
MODIFY COLUMN kategori_k_id INT AUTO_INCREMENT;

ALTER TABLE film
ADD CONSTRAINT film_kategori_fk FOREIGN KEY (kategori_k_id) REFERENCES kategori(k_id);

-- Input data dokumenter dan science fiction ke kategori 
INSERT INTO kategori (k_jenis_kategori)
VALUES
('Documenter'),
('Science Fiction');

# 7
-- Insert pagawai baru
INSERT INTO pegawai
VALUES
('PE00000003', 'Valerie Gala', '6281576821444', 'valgala@gmail.com', '202 Getaway Street', 'F', 19, 'AK0002', 'intern');

-- Update transaksi dengan pegawai baru (Valeria Gala)
UPDATE transaksi_rental_film
SET pegawai_pe_nip = 'PE00000003'
WHERE trf_id = 'TRF0000004';

# 8 
-- Mengubah data reputasi pada tabel sutradara menjadi int
ALTER TABLE sutradara
MODIFY COLUMN st_reputasi INT;

# 9 
-- Membuat null kolom trf_denda pada tabel transaksi_rental_film
UPDATE transaksi_rental_film
SET trf_denda = NULL
WHERE customer_cs_nik = 'CUST000000000003' OR customer_cs_nik = 'CUST000000000004'; 

# 10
-- Menghapus data film yang rilis sebelum tahun 1990, hapus dahulu data yang ada di foreign key
DELETE FROM rental_film
WHERE film_f_id IN (SELECT f_id FROM film WHERE f_tahun_rilis < 1990);

DELETE FROM film
WHERE f_tahun_rilis < 1990;

# 11
-- Input data ke transaksi_rental_film 
INSERT INTO transaksi_rental_film
VALUES 
('TRF0000005', '2023-09-13', '2023-12-20', 40000, 'PE00000001', 'CUST000000000001');

INSERT INTO rental_film
VALUES
('F00003', 'TRF0000005');

-- Update stok film Gara-gara setelah rental
UPDATE film
SET f_stok = f_stok - 2
WHERE f_id = 'F00003';

-- Update data yang di rental_film karena salah. Update menjadi Gantiang dong
UPDATE rental_film
SET film_f_id = 'F00002'
WHERE transaksi_rental_film_trf_id = 'TRF0000005';

-- Update stok film Gara-gara setelah dikembalikan
UPDATE film
SET f_stok = f_stok + 2
WHERE f_id = 'F00003';

# 12
-- Drop semua constraint yang memiliki relasi dengan customer
ALTER TABLE no_telp
DROP CONSTRAINT no_telp_customer_FK;

ALTER TABLE transaksi_rental_film
DROP CONSTRAINT transaksi_rental_film_customer_FK;

ALTER TABLE rental_film
DROP CONSTRAINT rental_film_transaksi_rental_film_FK;

-- Add constraint dan tambahkan on delete cascade
ALTER TABLE no_telp
ADD CONSTRAINT no_telp_customer_FK FOREIGN KEY (customer_cs_nik) REFERENCES customer (cs_nik) ON DELETE CASCADE;

ALTER TABLE transaksi_rental_film
ADD CONSTRAINT transaksi_rental_film_customer_FK FOREIGN KEY (customer_cs_nik) REFERENCES customer (cs_nik) ON DELETE CASCADE;

ALTER TABLE rental_film
ADD CONSTRAINT rental_film_transaksi_rental_film_FK FOREIGN KEY (transaksi_rental_film_trf_id) REFERENCES transaksi_rental_film (trf_id) ON DELETE CASCADE;

-- Delete Customer
DELETE FROM customer
WHERE cs_nik = 'CUST000000000001';
