import '../models/question_model.dart';

/// Kumpulan pertanyaan kuis statis untuk keperluan development & testing.
/// Akan digantikan dengan sumber data dinamis pada tahap selanjutnya.
class DummyData {
  DummyData._(); // Cegah instantiasi — class ini bersifat utility/static.

  static const List<QuestionModel> questions = [
    QuestionModel(
      id: 1,
      questionText: 'Siapa penemu teori relativitas khusus?',
      options: [
        'Isaac Newton',
        'Albert Einstein',
        'Nikola Tesla',
        'Stephen Hawking',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Albert Einstein memperkenalkan teori relativitas khusus pada tahun 1905 '
          'melalui makalahnya yang berjudul "Zur Elektrodynamik bewegter Körper".',
    ),
    QuestionModel(
      id: 2,
      questionText: 'Bahasa pemrograman apa yang digunakan oleh Flutter?',
      options: ['Kotlin', 'Swift', 'Dart', 'JavaScript'],
      correctAnswerIndex: 2,
      explanation:
          'Flutter menggunakan bahasa Dart yang dikembangkan oleh Google. '
          'Dart dirancang untuk membangun aplikasi mobile, web, dan desktop.',
    ),
    QuestionModel(
      id: 3,
      questionText: 'Berapakah hasil dari 7 × 8?',
      options: ['54', '56', '58', '64'],
      correctAnswerIndex: 1,
      explanation: '7 × 8 = 56. Perkalian dasar ini sering muncul dalam tabel perkalian.',
    ),
    QuestionModel(
      id: 4,
      questionText: 'Apa ibu kota negara Jepang?',
      options: ['Osaka', 'Kyoto', 'Tokyo', 'Hiroshima'],
      correctAnswerIndex: 2,
      explanation:
          'Tokyo adalah ibu kota dan kota terbesar di Jepang. '
          'Kota ini menjadi pusat pemerintahan sejak era Meiji pada tahun 1869.',
    ),
    QuestionModel(
      id: 5,
      questionText: 'Planet manakah yang dikenal sebagai "Planet Merah"?',
      options: ['Venus', 'Jupiter', 'Mars', 'Saturnus'],
      correctAnswerIndex: 2,
      explanation:
          'Mars dijuluki "Planet Merah" karena permukaan dan atmosfernya kaya '
          'akan oksida besi (karat) yang memberikan warna kemerahan.',
    ),
    QuestionModel(
      id: 6,
      questionText:
          'Widget apa yang digunakan untuk membuat daftar bergulir di Flutter?',
      options: ['Column', 'ListView', 'Stack', 'GridView'],
      correctAnswerIndex: 1,
      explanation:
          'ListView adalah widget Flutter yang menampilkan daftar item '
          'yang dapat di-scroll secara vertikal maupun horizontal.',
    ),
    QuestionModel(
      id: 7,
      questionText: 'Unsur kimia dengan simbol "O" adalah?',
      options: ['Osmium', 'Oksigen', 'Emas', 'Ozon'],
      correctAnswerIndex: 1,
      explanation:
          'Simbol "O" pada tabel periodik mewakili Oksigen, '
          'unsur nomor 8 yang paling banyak terdapat di bumi.',
    ),
  ];
}
