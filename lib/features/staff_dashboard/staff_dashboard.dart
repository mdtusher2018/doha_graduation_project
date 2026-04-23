import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController controller = MobileScannerController();

  bool isProcessing = false;

  void _showResultDialog(String message, {bool notFound = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                notFound ? Icons.error_outline : Icons.verified,
                color: notFound ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 10),
              Text(notFound ? "Not Found" : "Scan Result"),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartScanner();
              },
              child: const Text("Scan Again"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _restartScanner();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
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
