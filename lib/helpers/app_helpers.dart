import 'dart:io';
import 'package:flutter/material.dart';

String formatRupiah(num amount) {
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String mathFunc(Match match) => '${match[1]}.';
  String result = amount.toStringAsFixed(0).replaceAllMapped(reg, mathFunc);
  return 'Rp $result';
}

Widget buildCustomImage(String imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
  if (imagePath.startsWith('assets/')) {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _errorBox(width, height, imagePath),
    );
  } else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _errorBox(width, height, imagePath),
    );
  } else if (imagePath.isNotEmpty && File(imagePath).existsSync()) {
    return Image.file(
      File(imagePath),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _errorBox(width, height, imagePath),
    );
  } else {
    return _errorBox(width, height, imagePath);
  }
}

Widget _errorBox(double? width, double? height, String path) {
  return Container(
    width: width,
    height: height,
    color: const Color(0xFFFCE4EC),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.broken_image, color: Colors.pink, size: 28),
        const SizedBox(height: 4),
        Text(
          'Gagal muat:\n$path',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Colors.pink),
        ),
      ],
    ),
  );
}