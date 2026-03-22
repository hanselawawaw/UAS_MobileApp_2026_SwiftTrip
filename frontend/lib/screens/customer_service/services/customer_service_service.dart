import '../models/faq_item.dart';
import '../models/recent_question.dart';
import '../models/cs_chat_models.dart';
import '../models/ticket_item.dart';
import '../models/cs_request.dart';

class CustomerServiceService {
  // TODO: Inject Dio or http client here
  // final Dio _dio;
  // CustomerServiceService(this._dio);

  Future<List<FaqItem>> getFaqs() async {
    // TODO: Implement GET /api/v1/customer-service/faqs
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    return const [
      FaqItem(
        question: 'Cara mengubah nama',
        answer:
            'Untuk mengubah nama, pergi ke halaman Profile > Edit Profile, lalu ubah nama kamu dan simpan.',
      ),
      FaqItem(
        question: 'AI tidak merespon',
        answer:
            'Jika AI tidak merespon, coba refresh halaman atau restart aplikasi. Pastikan koneksi internet kamu stabil.',
      ),
      FaqItem(
        question: 'Pembayaran Error',
        answer:
            'Jika mengalami error saat pembayaran, pastikan data kartu kamu benar dan coba lagi. Hubungi bank jika masalah berlanjut.',
      ),
      FaqItem(
        question: 'History belum muncul',
        answer:
            'History akan muncul setelah transaksi selesai diproses. Biasanya membutuhkan waktu 1-2 menit.',
      ),
    ];
  }

  Future<List<RecentQuestion>> getRecentQuestions() async {
    // TODO: Implement GET /api/v1/customer-service/recent-questions
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      RecentQuestion(
        id: 'RQ001',
        username: 'Wilson',
        question: 'How to get refund after accidentally press confirm?',
      ),
      RecentQuestion(
        id: 'RQ002',
        username: 'James',
        question: 'Can I change my booking date after payment?',
      ),
    ];
  }

  Future<List<TicketItem>> getTickets() async {
    // TODO: Implement GET /api/v1/customer-service/tickets
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      TicketItem(
        id: '1',
        title: 'Saldo tidak terupdate',
        issuedDate: '15 Jan 2026',
        preview:
            'Saldo terakhir tidak sesuai dengan transaksi terbaru. Mohon pengecekan karena nilai tidak berubah setelah pembayaran...',
        status: TicketStatus.pending,
        isPublic: true,
      ),
      TicketItem(
        id: '2',
        title: 'Gagal login aplikasi',
        issuedDate: '16 Jan 2026',
        preview:
            'Tidak bisa login meskipun username dan password sudah benar. Muncul error tidak dikenal saat mencoba masuk...',
        status: TicketStatus.pending,
        isPublic: true,
      ),
      TicketItem(
        id: '3',
        title: 'Notifikasi tidak masuk',
        issuedDate: '17 Jan 2026',
        preview:
            'Aplikasi tidak mengirim notifikasi transaksi terbaru. Sudah cek pengaturan tapi tetap tidak ada pemberitahuan...',
        status: TicketStatus.pending,
        isPublic: true,
      ),
      TicketItem(
        id: '4',
        title: 'Transaksi tertunda',
        issuedDate: '18 Jan 2026',
        preview:
            'Transaksi sudah dilakukan namun status masih pending lebih dari 24 jam. Mohon konfirmasi apakah berhasil atau tidak...',
        status: TicketStatus.pending,
        isPublic: true,
      ),
      TicketItem(
        id: '5',
        title: 'Error saat checkout',
        issuedDate: '19 Jan 2026',
        preview:
            'Terjadi error ketika menekan tombol checkout. Halaman tidak memproses dan kembali ke halaman sebelumnya...',
        status: TicketStatus.pending,
        isPublic: true,
      ),
    ];
  }

  Future<CsQuestion> getQuestionDetail(String ticketId) async {
    // TODO: Implement GET /api/v1/customer-service/tickets/{id}
    await Future.delayed(const Duration(milliseconds: 500));
    return const CsQuestion(
      username: 'Anonymous_121',
      subtitle: '12 des 2025 Refund request',
      body: 'How to get refund after accidentally press confirm?',
    );
  }

  Future<List<CsFeedbackEntry>> getFeedbackThread(String ticketId) async {
    // TODO: Implement GET /api/v1/customer-service/tickets/{id}/thread
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      CsFeedbackEntry(
        username: 'IT Team CS',
        date: '14 jan 2026',
        body:
            'Saldo yang tidak terupdate biasanya disebabkan oleh proses pembayaran yang masih dalam tahap verifikasi, keterlambatan dari pihak bank atau metode pembayaran yang digunakan, atau transaksi yang belum berhasil sepenuhnya. Silakan cek kembali status transaksi di riwayat pesanan Anda dan pastikan pembayaran sudah berhasil. Jika saldo belum juga masuk setelah beberapa waktu, kemungkinan ada kendala teknis atau sistem, sehingga disarankan untuk menghubungi layanan pelanggan dengan menyertakan bukti pembayaran agar dapat ditindaklanjuti lebih lanjut.',
        isAnswered: true,
      ),
      CsFeedbackEntry(
        username: 'Anonymous_121',
        date: '15 jan 2026',
        body: 'Thank you',
      ),
    ];
  }

  Future<void> postRequest(CsRequest request) async {
    // TODO: Implement POST /api/v1/customer-service/requests
    await Future.delayed(const Duration(seconds: 1));
    // Simulate success
  }

  Future<void> postReply(String ticketId, String body) async {
    // TODO: Implement POST /api/v1/customer-service/tickets/{id}/reply
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate success
  }

  Future<List<String>> getProblemTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'Bugs',
      'Text Error',
      'Button Malfunctions',
      'Design Error',
      'Others',
    ];
  }

  Future<List<String>> getLocations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Home', 'Chat AI', 'Keranjang', 'Pembayaran', 'Others'];
  }

  Future<List<String>> getPublishTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Public', 'Private'];
  }
}
