import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeadPiece extends StatelessWidget {
  const DeadPiece({
    super.key,
    required this.imagePath,
    required this.isWhite,
  });
  final String imagePath;
  final bool isWhite;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imagePath,
      color: isWhite ? Colors.white30 : Colors.grey.shade900,
    );
  }
}
