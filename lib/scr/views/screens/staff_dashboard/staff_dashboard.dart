import 'dart:convert';

import 'package:doha_graduation_project/core/theme/app_colors.dart';
import 'package:doha_graduation_project/core/utils/extensions/num_ext.dart';
import 'package:doha_graduation_project/scr/controllers/staff_dash_board_notifier.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_button.dart';
import 'package:doha_graduation_project/scr/views/shared/widgets/app_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class StaffDashboardPage extends ConsumerStatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  ConsumerState<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends ConsumerState<StaffDashboardPage> {
  final MobileScannerController controller = MobileScannerController();

  bool isProcessing = false;

  void _showResultDialog(String message, {bool notFound = false}) {
    dynamic data;

    try {
      if (message.contains('{')) {
        data = jsonDecode(message);
      }
    } catch (_) {}
    final dashboard = ref.watch(staffDashboardNotifierProvider.notifier);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ─── Handle ─────────────────────────
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),

              /// ─── Status Icon ─────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notFound
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                ),
                child: Icon(
                  notFound ? Icons.cancel : Icons.verified,
                  color: notFound ? Colors.red : Colors.green,
                  size: 32,
                ),
              ),

              const SizedBox(height: 12),

              /// ─── Title ───────────────────────────
              AppText.bodyLg(
                notFound
                    ? "Invalid QR Code"
                    : (data['role'] == 'student')
                    ? "Student"
                    : "Faculty",
                fontWeight: FontWeight.bold,
              ),

              24.verticalSpace,

              /// ─── User Info ───────────────────────
              if (data != null) ...[
                _infoRow("Name", data['name'] ?? "-"),
                _infoRow("Email", data['email'] ?? "-"),
                if (data['section'] != null)
                  _infoRow("Section", data['section'] ?? "-"),
                _infoRow("Seat", data['seat'] ?? "-"),
              ] else
                AppText.bodyLg(message, textAlign: TextAlign.center),

              24.verticalSpace,

              /// ─── Actions ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      onPressed: () {
                        Navigator.pop(context);
                        _restartScanner();
                      },
                      label: "Scan Again",
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: dashboard.isLoading,
                      builder: (context, value, child) {
                        return AppButton.primary(
                          onPressed: () async {
                            await dashboard.submitPresent(data['email'] ?? "-");

                            _restartScanner();
                          },
                          label: "Done",
                          isLoading: value,
                          backgroundColor: notFound ? Colors.red : Colors.green,
                        );
                      },
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _restartScanner() {
    setState(() {
      isProcessing = false;
    });
    controller.start();
  }

  void _onDetect(BarcodeCapture capture) {
    if (isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? data = barcodes.first.rawValue;

    setState(() {
      isProcessing = true;
    });

    controller.stop();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (data != null && data.trim().isNotEmpty) {
        _showResultDialog(data, notFound: false);
      } else {
        _showResultDialog("No valid QR data found.", notFound: true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          /// 🔲 FULL SCREEN SCANNER
          MobileScanner(controller: controller, onDetect: _onDetect),

          /// 🔳 TOP GRADIENT UI (professional overlay)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Center(
                child: Text(
                  "Scan QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),

          /// 🎯 SCAN FRAME UI (center overlay)
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// 🔘 BOTTOM INSTRUCTION
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Icon(Icons.qr_code_scanner, color: Colors.white70),
                SizedBox(height: 8),
                Text(
                  "Align QR code within frame to scan",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
