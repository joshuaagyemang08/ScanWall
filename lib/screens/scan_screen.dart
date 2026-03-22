import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'gallery_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Prevents the scanner firing multiple times on one QR.
  bool _hasScanned = false;

  // Controls the camera (start, stop, torch).
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final keyword = barcode?.rawValue;
    if (keyword == null || keyword.trim().isEmpty) return;

    _hasScanned = true;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GalleryScreen(keyword: keyword.trim()),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _hasScanned = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScanWall'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Point your camera at a QR code\nto browse wallpapers',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Try: sunset · ocean · forest · galaxy · city',
              style: TextStyle(fontSize: 13, color: Colors.white38),
            ),
          ),
        ],
      ),
    );
  }
}
