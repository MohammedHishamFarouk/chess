import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    this.onTap,
    required this.isValidMoves,
  });
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMoves;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    //if selected,square color will be green
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMoves) {
      squareColor = Colors.lightGreen;
    } else {
      squareColor = isWhite ? Colors.grey : Colors.grey.shade900;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMoves ? 8 : 0),
        child: piece != null
            ? SvgPicture.asset(
                piece!.imagePath,
                color: piece!.isWhite ? Colors.white : null,
              )
            : null,
      ),
    );
  }
}
