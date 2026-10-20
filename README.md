#  QuizApp — Aplikasi Kuis Pilihan Ganda

<p align="center">
  <img src="assets/images/logo_kuis.png" alt="Logo QuizApp" width="120"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-blue?logo=dart" />
  <img src="https://img.shields.io/badge/Provider-6.x-purple" />
  <img src="https://img.shields.io/badge/License-MIT-green" />
</p>

---

##  Identitas Mahasiswa

|                  |                    |
| ---------------- | ------------------ |
| **Nama**         | Rio Johanes        |
| **NIM**          | _241401020_        |
| **Laboratorium** | Pemrograman Mobile |

---

##  Informasi Aplikasi

### Nama Aplikasi

**QuizApp — Aplikasi Kuis Pilihan Ganda**

### Deskripsi Singkat

QuizApp adalah aplikasi kuis pilihan ganda berbasis Flutter yang memungkinkan pengguna untuk menguji pengetahuan mereka melalui serangkaian pertanyaan interaktif. Aplikasi ini dibangun dengan arsitektur yang bersih menggunakan **Provider** sebagai state management, mendukung **Light & Dark Mode**, serta didesain **adaptive & responsive** sehingga tampil rapi di HP maupun Tablet.

### Fitur-Fitur yang Tersedia

| #   | Fitur                          | Keterangan                                                                  |
| --- | ------------------------------ | --------------------------------------------------------------------------- |
| 1   | **Input Nama Pengguna**        | Form validasi nama sebelum memulai kuis                                     |
| 2   | **Kuis Pilihan Ganda**         | 7 soal dari berbagai topik (Sains, Flutter, Geografi, dll.)                 |
| 3   | **Feedback Jawaban Real-time** | Warna hijau/merah langsung saat memilih opsi                                |
| 4   | **Penjelasan Jawaban**         | Kotak penjelasan muncul setelah setiap soal dijawab                         |
| 5   | **Progress Bar**               | Indikator progres soal yang animatif                                        |
| 6   | **Skor Live di AppBar**        | Skor terupdate secara real-time selama kuis berlangsung                     |
| 7   | **Halaman Hasil**              | Skor akhir, predikat (Luar Biasa/Bagus/Semangat), dan statistik Benar/Salah |
| 8   | **Toggle Light / Dark Mode**   | Tombol di AppBar untuk beralih tema kapan saja                              |
| 9   | **State Persist saat Rotasi**  | State tidak hilang saat layar diputar (Provider)                            |
| 10  | **Adaptive & Responsive**      | Konten dibatasi max 600dp dan dipusatkan untuk tampilan Tablet/Web          |
| 11  | **Animasi Transisi**           | Animasi slide/fade antar halaman dan pada setiap widget                     |

---

##  Arsitektur & Teknologi

```
lib/
├── main.dart                  # Entry point + MultiProvider + MaterialApp
├── models/
│   └── question_model.dart    # Model data pertanyaan
├── providers/
│   └── quiz_provider.dart     # State management (ChangeNotifier)
├── screens/
│   ├── welcome_screen.dart    # Halaman input nama
│   ├── quiz_screen.dart       # Halaman soal kuis
│   └── result_screen.dart     # Halaman hasil akhir
├── theme/
│   └── app_theme.dart         # Konfigurasi Light & Dark theme
├── utils/
│   └── dummy_data.dart        # Data soal statis
└── widgets/
    ├── adaptive_layout.dart   # Wrapper responsive (ConstrainedBox + Center)
    ├── custom_button.dart     # Tombol kustom dengan LayoutBuilder
    ├── option_card.dart       # Kartu opsi jawaban dengan animasi
    └── question_card.dart     # Kartu pertanyaan dengan progress bar
```

| Teknologi    | Versi  | Kegunaan            |
| ------------ | ------ | ------------------- |
| Flutter      | 3.x    | Framework utama     |
| Dart         | 3.x    | Bahasa pemrograman  |
| Provider     | ^6.1.2 | State management    |
| Google Fonts | ^6.2.1 | Font Poppins kustom |

---

##  Screenshot

> **Petunjuk:** Jalankan aplikasi dengan `flutter run`, ambil screenshot setiap halaman,
> lalu simpan di folder `screenshots/` dan ganti placeholder di bawah ini.

### Welcome Screen

|           Light Mode            |           Dark Mode            |
| :-----------------------------: | :----------------------------: |
|    <img width="357" height="767" alt="image" src="https://github.com/user-attachments/assets/39fd5852-db7d-461a-97b8-a5ab8b8f858c" />     |    <img width="357" height="767" alt="image" src="https://github.com/user-attachments/assets/39fd5852-db7d-461a-97b8-a5ab8b8f858c" />    |

### Quiz Screen

|     Sebelum Menjawab     | Setelah Menjawab (Benar) | Setelah Menjawab (Salah) |
| :----------------------: | :----------------------: | :----------------------: |
| <img width="352" height="765" alt="image" src="https://github.com/user-attachments/assets/a720d5e5-4e76-49df-9439-220b70e4d6a7" />
 | <img width="356" height="767" alt="image" src="https://github.com/user-attachments/assets/ef476f66-e36b-4820-8bef-c3b23f17a5e3" />
 | <img width="351" height="766" alt="image" src="https://github.com/user-attachments/assets/ef193a4b-06a0-4952-b443-7bd0c9905087" />
 |

### Result Screen

|Skor Tinggi|
<img width="353" height="766" alt="image" src="https://github.com/user-attachments/assets/7b881236-7bed-4003-bf8a-ebee991a970b" />

|Skor Rendah|
<img width="357" height="768" alt="image" src="https://github.com/user-attachments/assets/865c7628-89c1-477f-8765-32be16321d64" />


---

## Cara Menjalankan Aplikasi

### Prasyarat

- Flutter SDK `^3.13.3`
- Android Studio / VS Code
- Perangkat Android / iOS / Emulator

### Langkah-langkah

```bash
# 1. Clone repository
git clone https://github.com/<username>/aplikasi_quiz.git
cd aplikasi_quiz

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

---

## Credit & Sumber Aset

| Aset                            | Sumber                                                                               | Lisensi                                          |
| ------------------------------- | ------------------------------------------------------------------------------------ | ------------------------------------------------ |
| `assets/images/logo_kuis.png`   | [Flaticon](https://www.flaticon.com/free-icons/quiz)                                 | [Flaticon License]                               |
| `assets/images/achievement.png` | [Flaticon](https://www.flaticon.com/free-icons/thropy)                               | [Flaticon License]                               |
| Font: **Poppins**               | [Google Fonts](https://fonts.google.com/specimen/Poppins)                            | [Open Font License](https://scripts.sil.org/OFL) |
| Ikon Material                   | [Material Icons — Google](https://fonts.google.com/icons)                            | Apache 2.0                                       |

---

## Tautan Penting

| **Video Presentasi**   |              |

---

<p align="center">Dibuat dengan menggunakan Flutter</p>
