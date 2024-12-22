# Aplikasi Pengelolaan Password
Aplikasi Pengelolaan Password ini memungkinkan pengguna untuk menyimpan, mengedit, menghapus, dan menampilkan password aplikasi secara aman. Setiap password yang disimpan akan terenkripsi menggunakan algoritma AES untuk menjaga kerahasiaan data. Aplikasi ini dibangun menggunakan Flutter dan SQLite untuk penyimpanan data lokal.

## Fitur Utama
- Tambah Password: Menambah password baru dengan aplikasi yang diinginkan, username, dan password.
- Edit Password: Mengedit password yang sudah disimpan.
- Hapus Password: Menghapus password yang tidak dibutuhkan lagi.
- Lihat Password: Menampilkan password yang disimpan setelah didekripsi.
- Enkripsi dan Dekripsi: Password yang disimpan akan terenkripsi dengan algoritma AES 128-bit. Dekripsi dilakukan saat password ditampilkan.

## Teknologi yang Digunakan
- Flutter: Framework untuk pengembangan aplikasi mobile.
- SQLite: Database lokal untuk menyimpan data pengguna dan password.
- AES (Advanced Encryption Standard): Algoritma enkripsi untuk melindungi password.
- Dart Crypto Library: Digunakan untuk hashing dan enkripsi.

## Instalasi

### Persyaratan Sistem
Pastikan Anda memiliki versi terbaru dari Flutter yang terinstal di sistem Anda. Jika belum, Anda dapat mengikuti panduan instalasi Flutter di dokumentasi Flutter.

### Langkah-langkah Instalasi
1. Clone repository ini:

```bash
git clone https://github.com/username/repository-name.git
cd repository-name
```

2. Install dependensi:

```bash
flutter pub get
```

3. Jalankan aplikasi di emulator atau perangkat fisik:

```bash
flutter run
```

## Cara Penggunaan
1. Menambah Password:

- Klik tombol Tambah Password pada halaman utama.
- Isi form dengan nama aplikasi, username, dan password.
- Password akan terenkripsi dan disimpan ke dalam database.

2. Mengedit Password:

- Pilih password yang ingin diedit dari daftar.
- Edit detail password dan klik Submit untuk menyimpan perubahan.

3. Menghapus Password:

- Pilih password yang ingin dihapus dari daftar dan klik ikon delete.
- Password akan dihapus dari database.

4. Melihat Password:

- Password yang tersimpan akan didekripsi dan ditampilkan pada UI.

## Struktur Direktori
```bash
lib/
├── main.dart                  # Titik masuk aplikasi
├── screens/
│   ├── password_list_screen.dart  # Tampilan daftar password
│   └── password_form.dart        # Form tambah/edit password
├── models/
│   └── password.dart            # Model data untuk password
└── helpers/
    ├── encryption_helper.dart  # Logika enkripsi dan dekripsi
    ├── database_password.dart  # Helper untuk operasi database pada password
    └── database_profile.dart   # Helper untuk operasi database pada profil pengguna
```

## Pengujian
Aplikasi ini telah diuji dengan berbagai kasus untuk memastikan bahwa password yang disimpan dapat dienkripsi dengan benar dan didekripsi kembali tanpa kesalahan. Pengujian juga dilakukan untuk memastikan UI berfungsi dengan baik di berbagai perangkat.

### Pengujian Enkripsi dan Dekripsi
- Password yang dimasukkan melalui form akan dienkripsi menggunakan AES sebelum disimpan.
- Saat menampilkan password, aplikasi akan mendekripsi password yang tersimpan dan menampilkan data yang sesuai.

### Pengujian UI
- Aplikasi ini telah diuji di berbagai perangkat dan ukuran layar untuk memastikan pengalaman pengguna yang responsif.

## Kontribusi
Jika Anda ingin berkontribusi pada proyek ini, ikuti langkah-langkah berikut:

1. Fork repositori ini.
2. Buat branch baru (git checkout -b fitur-baru).
3. Lakukan perubahan dan commit (git commit -am 'Menambahkan fitur baru').
4. Push ke branch (git push origin fitur-baru).
5. Buat pull request.

## Lisensi
Aplikasi ini dilisensikan di bawah GNU GPL License - lihat [LICENSE](./license) untuk lebih lanjut.