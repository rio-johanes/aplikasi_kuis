import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../utils/dummy_data.dart';

/// Status jawaban pengguna untuk satu pertanyaan.
enum AnswerStatus {
  /// Belum dijawab.
  unanswered,

  /// Jawaban benar.
  correct,

  /// Jawaban salah.
  incorrect,
}

/// State Management utama aplikasi kuis menggunakan [ChangeNotifier].
///
/// Menyimpan dan mengelola seluruh state:
/// - Nama pengguna
/// - Skor saat ini
/// - Indeks pertanyaan aktif
/// - Status tema (light/dark)
/// - Status jawaban per pertanyaan
class QuizProvider extends ChangeNotifier {
  // ── Internal State ────────────────────────────────────────────────────────

  /// Daftar soal yang digunakan dalam sesi kuis ini.
  final List<QuestionModel> _questions = List.from(DummyData.questions);

  /// Nama pengguna yang diisi di layar awal.
  String _userName = '';

  /// Skor akumulatif sesi kuis saat ini.
  int _score = 0;

  /// Indeks pertanyaan yang sedang ditampilkan (0-based).
  int _currentQuestionIndex = 0;

  /// Status apakah tampilan saat ini menggunakan dark mode.
  bool _isDarkMode = false;

  /// Indeks opsi yang dipilih pengguna pada pertanyaan aktif.
  /// Bernilai -1 jika belum ada pilihan.
  int _selectedAnswerIndex = -1;

  /// Status jawaban pengguna pada pertanyaan aktif.
  AnswerStatus _answerStatus = AnswerStatus.unanswered;

  /// Menyimpan indeks opsi yang dipilih untuk setiap pertanyaan.
  /// Key: indeks pertanyaan, Value: indeks opsi yang dipilih.
  final Map<int, int> _answeredQuestions = {};

  // ── Getters (Read-Only untuk UI) ──────────────────────────────────────────

  /// Seluruh daftar pertanyaan.
  List<QuestionModel> get questions => List.unmodifiable(_questions);

  /// Nama pengguna yang sedang login/bermain.
  String get userName => _userName;

  /// Skor saat ini.
  int get score => _score;

  /// Indeks pertanyaan yang sedang aktif.
  int get currentQuestionIndex => _currentQuestionIndex;

  /// Apakah tema saat ini adalah dark mode.
  bool get isDarkMode => _isDarkMode;

  /// `ThemeMode` yang sesuai dengan state [isDarkMode].
  /// Digunakan langsung oleh `MaterialApp`.
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Indeks opsi yang dipilih pada pertanyaan aktif (-1 = belum dipilih).
  int get selectedAnswerIndex => _selectedAnswerIndex;

  /// Status jawaban pada pertanyaan aktif.
  AnswerStatus get answerStatus => _answerStatus;

  /// Pertanyaan yang sedang aktif.
  QuestionModel get currentQuestion => _questions[_currentQuestionIndex];

  /// Total jumlah pertanyaan dalam kuis.
  int get totalQuestions => _questions.length;

  /// Nomor pertanyaan saat ini (1-based, untuk ditampilkan ke user).
  int get currentQuestionNumber => _currentQuestionIndex + 1;

  /// Apakah pengguna sudah menjawab pertanyaan aktif.
  bool get hasAnswered => _answerStatus != AnswerStatus.unanswered;

  /// Apakah ini pertanyaan terakhir.
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  /// Persentase progres kuis (0.0 – 1.0).
  double get progressPercent => (_currentQuestionIndex + 1) / _questions.length;

  // ── Methods ───────────────────────────────────────────────────────────────

  /// Menyimpan nama pengguna dari layar input nama.
  void setUserName(String name) {
    _userName = name.trim();
    notifyListeners();
  }

  /// Memproses jawaban pengguna pada pertanyaan aktif.
  ///
  /// - Mencatat pilihan di [_answeredQuestions].
  /// - Menambah [_score] sebesar 1 jika jawaban benar.
  /// - Mengubah [_answerStatus] sesuai hasil.
  /// - Memanggil [notifyListeners] agar UI diperbarui.
  ///
  /// Tidak melakukan apa-apa jika pertanyaan sudah dijawab sebelumnya.
  void answerQuestion(int selectedIndex) {
    // Guard: abaikan jika sudah dijawab.
    if (hasAnswered) return;

    _selectedAnswerIndex = selectedIndex;
    _answeredQuestions[_currentQuestionIndex] = selectedIndex;

    final isCorrect = currentQuestion.isCorrect(selectedIndex);

    if (isCorrect) {
      _score++;
      _answerStatus = AnswerStatus.correct;
    } else {
      _answerStatus = AnswerStatus.incorrect;
    }

    notifyListeners();
  }

  /// Melanjutkan ke pertanyaan berikutnya.
  ///
  /// Hanya bisa dipanggil jika pertanyaan aktif sudah dijawab
  /// dan bukan pertanyaan terakhir.
  /// Mengembalikan `true` jika berhasil berpindah, `false` jika sudah di akhir.
  bool nextQuestion() {
    if (!hasAnswered || isLastQuestion) return false;

    _currentQuestionIndex++;
    _selectedAnswerIndex = -1;
    _answerStatus = AnswerStatus.unanswered;

    notifyListeners();
    return true;
  }

  /// Mereset seluruh state kuis ke kondisi awal.
  ///
  /// Nama pengguna dan preferensi tema **tidak** direset
  /// agar pengguna tidak perlu mengisi ulang namanya.
  void resetQuiz() {
    _score = 0;
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = -1;
    _answerStatus = AnswerStatus.unanswered;
    _answeredQuestions.clear();
    notifyListeners();
  }

  /// Mengubah (toggle) tema antara light mode dan dark mode.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  /// Mengatur tema secara eksplisit.
  void setDarkMode({required bool value}) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Mengecek apakah pertanyaan dengan [questionIndex] sudah dijawab.
  bool isQuestionAnswered(int questionIndex) =>
      _answeredQuestions.containsKey(questionIndex);

  /// Mengambil indeks opsi yang dipilih untuk [questionIndex].
  /// Mengembalikan -1 jika belum dijawab.
  int getSelectedAnswerFor(int questionIndex) =>
      _answeredQuestions[questionIndex] ?? -1;

  @override
  String toString() {
    return 'QuizProvider('
        'user: $_userName, '
        'score: $_score/$totalQuestions, '
        'question: ${_currentQuestionIndex + 1}/$totalQuestions, '
        'darkMode: $_isDarkMode'
        ')';
  }
}
