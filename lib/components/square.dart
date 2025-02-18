import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Square extends StatelessWidget {
  const Square({super.key, required this.isWhite, required this.piece});
  final bool isWhite;
  final ChessPiece? piece;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? Colors.grey : Colors.grey.shade900,
      child: piece != null
          ? SvgPicture.asset(
              piece!.imagePath,
              color: piece!.isWhite ? Colors.white : null,
            )
          : null,
    );
  }
}
