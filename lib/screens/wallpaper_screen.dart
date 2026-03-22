import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/material.dart';

class WallpaperScreen extends StatefulWidget {
  final String imageUrl;
  final String keyword;

  const WallpaperScreen({
    super.key,
    required this.imageUrl,
    required this.keyword,
  });

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  bool _isLoading = false;
  String _statusMessage = '';

  Future<void> _setWallpaper(int location, String locationLabel) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Setting $locationLabel wallpaper...';
    });

    try {
      final success = await AsyncWallpaper.setWallpaper(
        url: widget.imageUrl,
        wallpaperLocation: location,
        toastDetails: ToastDetails.success(),
        errorToastDetails: ToastDetails.error(),
      );

      setState(() {
        _statusMessage = success
            ? '$locationLabel wallpaper set!'
            : 'Could not set wallpaper. Try again.';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      '"${widget.keyword}"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _statusMessage,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else ...[
                    _WallpaperButton(
                      label: 'Set Home Screen',
                      icon: Icons.home_outlined,
                      onTap: () => _setWallpaper(
                        AsyncWallpaper.HOME_SCREEN,
                        'home screen',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _WallpaperButton(
                      label: 'Set Lock Screen',
                      icon: Icons.lock_outline,
                      onTap: () => _setWallpaper(
                        AsyncWallpaper.LOCK_SCREEN,
                        'lock screen',
                      ),
                    ),
                    const SizedBox(height: 10),
                    _WallpaperButton(
                      label: 'Set Both Screens',
                      icon: Icons.smartphone,
                      isPrimary: true,
                      onTap: () => _setWallpaper(
                        AsyncWallpaper.BOTH_SCREENS,
                        'both screens',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WallpaperButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _WallpaperButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.deepPurpleAccent : Colors.white24,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
