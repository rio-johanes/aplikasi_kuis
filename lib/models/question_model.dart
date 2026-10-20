/// Model data untuk satu pertanyaan kuis pilihan ganda.
class QuestionModel {
  /// ID unik pertanyaan.
  final int id;

  /// Teks pertanyaan yang ditampilkan ke pengguna.
  final String questionText;

  /// Daftar pilihan jawaban (minimal 2, biasanya 4 opsi).
  final List<String> options;

  /// Indeks dari [options] yang merupakan jawaban benar (0-based).
  final int correctAnswerIndex;

  /// Penjelasan singkat tentang jawaban benar (opsional, untuk halaman hasil).
  final String? explanation;

  const QuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  /// Mengembalikan teks jawaban yang benar.
  String get correctAnswerText => options[correctAnswerIndex];

  /// Mengecek apakah indeks yang diberikan adalah jawaban benar.
  bool isCorrect(int selectedIndex) => selectedIndex == correctAnswerIndex;

  @override
  String toString() {
    return 'QuestionModel(id: $id, question: "$questionText")';
  }
}
