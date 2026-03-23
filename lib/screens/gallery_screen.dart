import 'package:flutter/material.dart';
import 'wallpaper_screen.dart';

class GalleryScreen extends StatefulWidget {
  final String keyword;

  const GalleryScreen({super.key, required this.keyword});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // The index of the image the user has tapped
  int? _selectedIndex;

  // Generate 12 unique image URLs using the keyword as a seed
  // Picsum uses the seed to always return the same image for the same seed
  // so "sunset1", "sunset2" etc. each give a different but consistent image
  late final List<String> _imageUrls = List.generate(
    12,
    (i) => 'https://picsum.photos/seed/${widget.keyword}$i/400/600',
  );

  void _onImageTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onConfirm() {
    if (_selectedIndex == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WallpaperScreen(
          imageUrl: _imageUrls[_selectedIndex!],
          keyword: widget.keyword,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('"${widget.keyword}" wallpapers'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Tap an image to select it',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),

          // Image grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio:
                    0.65, // portrait ratio, like a phone wallpaper
              ),
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onImageTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        // Highlight selected image with a purple border
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // The image itself
                          Image.network(
                            _imageUrls[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.white10,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.white10,
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.white30,
                              ),
                            ),
                          ),

                          // Checkmark overlay when selected
                          if (isSelected)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Confirm button at the bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  disabledBackgroundColor: Colors.white12,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedIndex != null
                      ? 'Use this wallpaper'
                      : 'Select an image first',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
