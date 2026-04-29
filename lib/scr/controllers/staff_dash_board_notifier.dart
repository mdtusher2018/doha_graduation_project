import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/base-notifier.dart';
import '../../../core/services/network/api_endpoints.dart';
import '../../../core/services/network/dio_client.dart';

final staffDashboardNotifierProvider =
    StateNotifierProvider<StaffDashboardNotifier, void>((ref) {
      final dio = ref.read(dioClientProvider);
      return StaffDashboardNotifier(dio: dio);
    });

class StaffDashboardNotifier extends BaseNotifier {
  StaffDashboardNotifier({required this.dio}) : super(null);

  final Dio dio;

  // ─── Fetch Dashboard Data ─────────────────────────
  Future<bool?> submitPresent() async {
    return safeCall<bool>(
      task: () async {
        final response = await dio.patch(
          ApiEndpoints.staffDashboard,
          data: {"email": "vebobe1663@hacknapp2.com"},
        );

        final data = response.data['success'];
        if (!data) {
          throw Exception(response.data['message']);
        }
        return data;
      },

      showSuccessSnack: true,
      successMessage: "Sucessfully attented",
    );
  }
}
