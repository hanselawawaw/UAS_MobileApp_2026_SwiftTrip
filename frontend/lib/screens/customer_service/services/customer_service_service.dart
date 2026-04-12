import 'package:dio/dio.dart';
import '../../../core/constants.dart';
import '../../../repositories/auth_repository.dart';
import '../models/faq_item.dart';
import '../models/recent_question.dart';
import '../models/cs_chat_models.dart';
import '../models/ticket_item.dart';
import '../models/cs_request.dart';

class CustomerServiceService {
  final AuthRepository _auth = AuthRepository();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Constants.supportUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Options> _authOptions() async {
    final token = await _auth.getToken();
    
    // Diagnostic log for local debugging
    if (token == null) {
      print('[AUTH DEBUG] WARNING: Token is NULL. Sending request without authorization.');
    } else {
      final preview = token.length > 10 ? '${token.substring(0, 10)}...' : token;
      print('[AUTH DEBUG] Token exists: $preview');
    }

    return Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
      },
      validateStatus: (status) => status != null && status < 500,
    );
  }

  // ── FAQs (kept as local data — no backend endpoint change needed) ──────

  Future<List<FaqItem>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 300));
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

  // ── Tickets (real HTTP) ────────────────────────────────────────────────

  Future<List<RecentQuestion>> getRecentQuestions() async {
    try {
      final response = await _dio.get('tickets/', options: await _authOptions());
      final List data = response.data as List;
      return data.map((e) => RecentQuestion.fromJson(e)).toList();
    } catch (e) {
      print('getRecentQuestions error: $e');
      return [];
    }
  }

  Future<List<TicketItem>> getTickets() async {
    try {
      final response = await _dio.get('tickets/', options: await _authOptions());
      final List data = response.data as List;
      return data.map((e) => TicketItem.fromJson(e)).toList();
    } catch (e) {
      print('getTickets error: $e');
      return [];
    }
  }

  Future<CsQuestion> getQuestionDetail(String ticketId) async {
    final response = await _dio.get('tickets/$ticketId/', options: await _authOptions());
    return CsQuestion.fromJson(response.data);
  }

  Future<List<CsFeedbackEntry>> getFeedbackThread(String ticketId) async {
    try {
      final response = await _dio.get('tickets/$ticketId/thread/', options: await _authOptions());
      final List data = response.data as List;
      return data.map((e) => CsFeedbackEntry.fromJson(e)).toList();
    } catch (e) {
      print('getFeedbackThread error: $e');
      return [];
    }
  }

  // ── Create ticket ──────────────────────────────────────────────────────

  Future<void> postRequest(CsRequest request) async {
    await _dio.post(
      'tickets/',
      data: {
        'problem_type': request.problemType,
        'location': request.location,
        'publish_type': request.publishType,
        'header': request.header,
        'statement': request.statement,
      },
      options: await _authOptions(),
    );
  }

  // ── Reply & AI generation ─────────────────────────────────────────────

  Future<void> postReply(String ticketId, String body) async {
    await _dio.post(
      'tickets/$ticketId/reply/',
      data: {'body': body},
      options: await _authOptions(),
    );
  }

  Future<List<CsFeedbackEntry>> generateAiReply(String ticketId) async {
    try {
      final response = await _dio.post(
        'tickets/$ticketId/generate_ai_reply/',
        options: await _authOptions(),
      );
      if (response.data is List) {
        return (response.data as List).map((e) => CsFeedbackEntry.fromJson(e)).toList();
      }
      return [CsFeedbackEntry.fromJson(response.data)];
    } catch (e) {
      print('generateAiReply error: $e');
      return [];
    }
  }

  // ── Metadata (local choices) ───────────────────────────────────────────

  Future<List<String>> getProblemTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ['Bugs', 'Text Error', 'Button Malfunctions', 'Design Error', 'Others'];
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
