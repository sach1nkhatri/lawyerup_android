import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum SnackType { success, error, warning }

class GlobalSnackBar {
  static final _player = AudioPlayer();

  static void show(
      BuildContext context,
      String message, {
        SnackType type = SnackType.success,
        Duration duration = const Duration(seconds: 3),
      }) {
    // Dismiss existing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    Color backgroundColor;
    IconData icon;
    String soundAsset;

    switch (type) {
      case SnackType.success:
        backgroundColor = Colors.green.shade600;
        icon = Icons.check_circle_outline;
        soundAsset = 'sounds/success.mp3';
        break;
      case SnackType.error:
        backgroundColor = Colors.red.shade600;
        icon = Icons.error_outline;
        soundAsset = 'sounds/failed.mp3';
        break;
      case SnackType.warning:
        backgroundColor = Colors.orange.shade800;
        icon = Icons.warning_amber_outlined;
        soundAsset = 'sounds/failed.mp3';
        break;
    }

    // Play sound (non-blocking)
    _player.play(AssetSource(soundAsset));

    // Show SnackBar
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
