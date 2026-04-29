import 'package:doha_graduation_project/scr/models/dashboard_model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/base-notifier.dart';
import '../../../core/services/network/api_endpoints.dart';
import '../../../core/services/network/dio_client.dart';

final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardResponse?>((ref) {
      final dio = ref.read(dioClientProvider);
      return DashboardNotifier(dio: dio);
    });

class DashboardNotifier extends BaseNotifier<DashboardResponse?> {
  DashboardNotifier({required this.dio}) : super(null);

  final Dio dio;

  // ─── Fetch Dashboard Data ─────────────────────────
  Future<DashboardResponse?> fetchDashboard() async {
    return safeCall<DashboardResponse>(
      task: () async {
        final response = await dio.get(ApiEndpoints.dashboard);

        final data = DashboardResponse.fromJson(response.data);

        // 🔥 store in state
        state = data;

        return data;
      },

      showSuccessSnack: false, // usually no need for success toast
    );
  }
}
