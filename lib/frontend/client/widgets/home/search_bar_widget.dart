import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_aura/frontend/theme/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.controller,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      debugPrint("Camera Image: ${image.path}");
    }
  }

  Future<void> _openGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      debugPrint("Gallery Image: ${image.path}");
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      "Choose Image",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: const Text("Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    _openCamera();
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: const Text("Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _openGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),

          const Icon(
            Icons.search_rounded,
            color: AppColors.textSoft,
            size: 28,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: "Search products...",
                hintStyle: TextStyle(
                  color: AppColors.textSoft,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),

          IconButton(
            onPressed: _showImagePicker,
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.primary,
            ),
          ),

          IconButton(
            onPressed: () {
              // Voice Search (Coming Soon)
            },
            icon: const Icon(
              Icons.mic_none_rounded,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 6),
        ],
      ),
    );
  }
}