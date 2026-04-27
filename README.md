# Tumbas App (Flutter Mobile Modul)

Aplikasi mobile Flutter untuk **toko sederhana** dengan role **user** dan **admin**. Project ini menggunakan **Provider** untuk state (user & cart), **HTTP** untuk komunikasi API, dan **BLoC** untuk halaman riwayat transaksi.

## Core aplikasi

- **Auth**
  - Login & Register
  - Session/token disimpan di `shared_preferences`
- **Role**
  - **User**: lihat produk, tambah ke keranjang, pesan, lihat riwayat, profil
  - **Admin**: dashboard admin, manajemen produk, profil
- **Cart & Transaksi**
  - State keranjang memakai `CartProvider`
  - Submit transaksi memakai `ServiceUser.buatTransaksi()` dengan payload:
    - `{'pesan': [{'barang_id': <id>, 'qty': <qty>}, ...]}`

## Tampilan/fitur UI utama

- **Dashboard (User)**
  - Menampilkan **nama user**
  - Sapaan otomatis berdasarkan waktu: **Selamat Pagi/Siang/Sore/Malam** (pakai `DateTime.now()`)
- **Product List**
  - Tombol tambah ke cart per item
  - Ikon cart di `AppBar` + badge jumlah item
- **Product Detail**
  - Pilih quantity, tambah ke cart, beli sekarang
  - Ikon cart di `AppBar` + badge jumlah item
- **Cart**
  - List item + tombol + / - / hapus
  - Menampilkan **gambar produk** (dari `item.image`)
  - Tombol:
    - **Pesan**: submit ke API, jika sukses cart otomatis kosong
    - **Batal**: kosongkan cart
- **History (Riwayat Transaksi)**
  - Mengambil data riwayat transaksi via BLoC

## Struktur folder (inti)

Semua source ada di:

- `lib/main.dart`: entry point + provider setup + route utama
- `lib/Apps/core/`
  - `models/`: model data
  - `provider/`: provider (`UserProvider`, `CartProvider`, dll.)
  - `service/`: service API (mis. `ServiceUser`)
  - `utils/`: konstanta API, helper, dll.
  - `widget/`: widget reusable (alert, dialog, dll.)
- `lib/Apps/features/presentation/`
  - `pages/`: halaman UI (auth, user, admin)
  - `controller/`: sistem navbar
  - `bloc/`: BLoC untuk riwayat transaksi

## Setup & menjalankan aplikasi

### Prasyarat

- Flutter SDK (sesuai `environment sdk: ^3.11.0`)
- Android Studio / VSCode + emulator atau device

### Jalankan (tanpa git clone)

Jika kamu sudah punya folder project ini di komputer:

```bash
cd Flutter_Mobile_Modul
flutter pub get
flutter run
```

## Opsi: git clone (struktur folder)

Kalau project ini ada di repository Git, contoh cara clone dan jalankan:

```bash
git clone <https://github.com/NauvalFaiz/Apps_Transaksi_toko> Flutter_Mobile_Modul
cd Flutter_Mobile_Modul
flutter pub get
flutter run
```

Catatan: pastikan kamu menjalankan perintah di folder root yang berisi `pubspec.yaml`.

## Endpoint API (ringkas)

Konstanta base URL ada di:

- `lib/Apps/core/utils/Api/api_constans_api_backend.dart`

Transaksi user memakai:

- `POST /user/transaksi` (lihat `ServiceUser.buatTransaksi`)
