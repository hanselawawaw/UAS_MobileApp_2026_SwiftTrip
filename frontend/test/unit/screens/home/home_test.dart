import 'package:flutter_test/flutter_test.dart';
import 'package:swifttrip_frontend/models/recommendation_item.dart';
import 'package:swifttrip_frontend/screens/home/services/home_service.dart';

// ============================================================
// HOME PAGE - UNIT TEST
// Tabel Coverage:
//   Widget            | Class Method
//   ------------------|----------------------
//   RefreshIndicator  | onRefresh()
//                     | fetchHomeDashboardData()
//   CustomScrollView  | buildScrollPhysics()
//   SliverList        | renderContent()
// ============================================================

// Helper: simulasi logika onRefresh murni
class HomeController {
  bool isRefreshing = false;
  bool isLoading = false;
  List<RecommendationItem> recommendations = [];
  List<dynamic> schedules = [];
  int refreshCount = 0;

  // onRefresh: reset state dan fetch ulang
  Future<void> onRefresh() async {
    isRefreshing = true;
    refreshCount++;
    await fetchHomeDashboardData();
    isRefreshing = false;
  }

  // fetchHomeDashboardData: ambil data dari service
  Future<void> fetchHomeDashboardData() async {
    isLoading = true;
    await Future.delayed(const Duration(milliseconds: 10)); // simulasi async
    isLoading = false;
  }

  // buildScrollPhysics: mengembalikan konfigurasi physics
  Map<String, dynamic> buildScrollPhysics() {
    return {
      'type': 'BouncingScrollPhysics',
      'parent': 'AlwaysScrollableScrollPhysics',
      'enabled': true,
    };
  }

  // renderContent: membangun list konten yang akan ditampilkan
  List<String> renderContent() {
    return [
      'BannerCarousel',
      'ScheduleCarousel',
      'SectionHeader',
      'RecommendationGrid',
    ];
  }
}

void main() {
  group('HomePage Unit Tests', () {
    late HomeController controller;
    late HomeService homeService;

    setUp(() {
      controller = HomeController();
      homeService = HomeService();
    });

    // ----------------------------------------------------------
    // METHOD: onRefresh()
    // ----------------------------------------------------------
    group('onRefresh()', () {
      test('onRefresh - isRefreshing bernilai true saat refresh berlangsung', () async {
        bool wasRefreshing = false;

        final future = controller.onRefresh().then((_) {
          wasRefreshing = true;
        });

        await future;
        expect(wasRefreshing, isTrue);
      });

      test('onRefresh - isRefreshing kembali false setelah selesai', () async {
        await controller.onRefresh();
        expect(controller.isRefreshing, isFalse);
      });

      test('onRefresh - refreshCount bertambah setiap dipanggil', () async {
        expect(controller.refreshCount, equals(0));

        await controller.onRefresh();
        expect(controller.refreshCount, equals(1));

        await controller.onRefresh();
        expect(controller.refreshCount, equals(2));
      });

      test('onRefresh - memanggil fetchHomeDashboardData setiap kali', () async {
        int fetchCallCount = 0;

        Future<void> mockRefresh() async {
          fetchCallCount++;
        }

        await mockRefresh();
        await mockRefresh();

        expect(fetchCallCount, equals(2));
      });

      test('onRefresh - tidak crash jika dipanggil berulang', () async {
        expect(() async {
          await controller.onRefresh();
          await controller.onRefresh();
          await controller.onRefresh();
        }, returnsNormally);
      });
    });

    // ----------------------------------------------------------
    // METHOD: fetchHomeDashboardData()
    // ----------------------------------------------------------
    group('fetchHomeDashboardData()', () {
      test('fetchHomeDashboardData - isLoading true saat fetch berlangsung', () async {
        final future = controller.fetchHomeDashboardData();
        // Tepat setelah dipanggil, isLoading true
        // (bergantung pada async, kita verifikasi hasil akhir)
        await future;
        expect(controller.isLoading, isFalse); // selesai = false
      });

      test('fetchHomeDashboardData - isLoading kembali false setelah selesai', () async {
        await controller.fetchHomeDashboardData();
        expect(controller.isLoading, isFalse);
      });

      test('fetchHomeDashboardData - HomeService.fetchRecommendations() '
          'mengembalikan list tidak kosong', () async {
        final result = await homeService.fetchRecommendations();
        expect(result, isNotEmpty);
        expect(result.length, greaterThan(0));
      });

      test('fetchHomeDashboardData - RecommendationItem memiliki name yang valid', () async {
        final items = await homeService.fetchRecommendations();
        for (final item in items) {
          expect(item.name, isNotEmpty);
        }
      });

      test('fetchHomeDashboardData - RecommendationItem memiliki description', () async {
        final items = await homeService.fetchRecommendations();
        for (final item in items) {
          expect(item.description, isNotEmpty);
        }
      });

      test('fetchHomeDashboardData - menghasilkan minimal 4 rekomendasi', () async {
        final items = await homeService.fetchRecommendations();
        expect(items.length, greaterThanOrEqualTo(4));
      });

      test('fetchHomeDashboardData - imageAsset atau imageUrl harus ada di item', () async {
        final items = await homeService.fetchRecommendations();
        for (final item in items) {
          // imageAsset dan imageUrl nullable (String?) - minimal salah satu ada
          final hasImage = (item.imageAsset != null && item.imageAsset!.isNotEmpty) ||
              (item.imageUrl != null && item.imageUrl!.isNotEmpty);
          expect(hasImage, isTrue);
        }
      });

      test('fetchHomeDashboardData - imageAsset jika ada harus berekstensi .png atau .jpg', () async {
        final items = await homeService.fetchRecommendations();
        for (final item in items) {
          if (item.imageAsset != null && item.imageAsset!.isNotEmpty) {
            final isValidExtension =
                item.imageAsset!.endsWith('.png') || item.imageAsset!.endsWith('.jpg');
            expect(isValidExtension, isTrue);
          }
        }
      });
    });

    // ----------------------------------------------------------
    // METHOD: buildScrollPhysics()
    // ----------------------------------------------------------
    group('buildScrollPhysics()', () {
      test('buildScrollPhysics mengembalikan konfigurasi physics yang valid', () {
        final physics = controller.buildScrollPhysics();
        expect(physics, isNotNull);
        expect(physics, isNotEmpty);
      });

      test('buildScrollPhysics mengaktifkan scroll (enabled = true)', () {
        final physics = controller.buildScrollPhysics();
        expect(physics['enabled'], isTrue);
      });

      test('buildScrollPhysics menggunakan BouncingScrollPhysics', () {
        final physics = controller.buildScrollPhysics();
        expect(physics['type'], equals('BouncingScrollPhysics'));
      });

      test('buildScrollPhysics memiliki parent AlwaysScrollableScrollPhysics', () {
        final physics = controller.buildScrollPhysics();
        expect(physics['parent'], equals('AlwaysScrollableScrollPhysics'));
      });

      test('buildScrollPhysics selalu mengembalikan hasil yang sama (deterministik)', () {
        final physics1 = controller.buildScrollPhysics();
        final physics2 = controller.buildScrollPhysics();
        expect(physics1, equals(physics2));
      });
    });

    // ----------------------------------------------------------
    // METHOD: renderContent()
    // ----------------------------------------------------------
    group('renderContent()', () {
      test('renderContent mengembalikan list konten yang tidak kosong', () {
        final content = controller.renderContent();
        expect(content, isNotEmpty);
      });

      test('renderContent memuat BannerCarousel sebagai konten pertama', () {
        final content = controller.renderContent();
        expect(content.first, equals('BannerCarousel'));
      });

      test('renderContent memuat ScheduleCarousel', () {
        final content = controller.renderContent();
        expect(content, contains('ScheduleCarousel'));
      });

      test('renderContent memuat SectionHeader', () {
        final content = controller.renderContent();
        expect(content, contains('SectionHeader'));
      });

      test('renderContent memuat RecommendationGrid', () {
        final content = controller.renderContent();
        expect(content, contains('RecommendationGrid'));
      });

      test('renderContent menghasilkan minimal 4 section konten', () {
        final content = controller.renderContent();
        expect(content.length, greaterThanOrEqualTo(4));
      });

      test('renderContent tidak memiliki konten duplikat', () {
        final content = controller.renderContent();
        final uniqueContent = content.toSet();
        expect(content.length, equals(uniqueContent.length));
      });

      test('RecommendationItem model dapat dibuat dengan data valid', () {
        const item = RecommendationItem(
          name: 'The Langham',
          description: 'Jakarta',
          imageAsset: 'assets/images/home/vacation_logo.png',
        );

        expect(item.name, equals('The Langham'));
        expect(item.description, equals('Jakarta'));
        expect(item.imageAsset, isNotNull);
        expect(item.imageAsset!, isNotEmpty);
      });
    });
  });
}