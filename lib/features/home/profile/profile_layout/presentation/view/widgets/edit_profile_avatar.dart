import 'dart:io';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfileAvatar extends StatelessWidget {
  final String photoUrl;
  final File? imageFile;
  final VoidCallback onPickImage;

  const EditProfileAvatar({
    super.key,
    required this.photoUrl,
    this.imageFile,
    required this.onPickImage,
  });

  bool get _isValidUrl {
    final uri = Uri.tryParse(photoUrl);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    const double avatarDiameter = 92.0;

    return Center(
      child: Stack(
        children: [
          Container(
            width: avatarDiameter,
            height: avatarDiameter,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white70,
            ),
            child: ClipOval(
              child: _buildAvatarImage(avatarDiameter),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.whiteBase,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey10,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 16,
                  color: AppColors.blackBase,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(double diameter) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
      );
    }
   
    if (_isValidUrl) {
      return Image.network(
        photoUrl,
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildPlaceholder(diameter),
      );
    }

    return _buildPlaceholder(diameter);
  }

  Widget _buildPlaceholder(double diameter) {
    return SvgPicture.asset(
      AppImages.appLogo,
      width: diameter,
      height: diameter,
      fit: BoxFit.cover,
    );
  }
}