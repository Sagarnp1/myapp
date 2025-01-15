import 'package:flutter/material.dart';
class WavyHeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomWaveClipper(),
      child: Image.asset(
        'assets/light1.jpg',
        fit: BoxFit.cover,
        height: 400, // Adjust based on your design
        width: double.infinity,
      ),
    );
  }
}

class CustomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the top-left corner
    path.lineTo(0, size.height * 0.6);

    // First curve (left dip)
    var firstControlPoint = Offset(size.width * 0.2, size.height * 0.4);
    var firstEndPoint = Offset(size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve (deep middle wave)
    var secondControlPoint = Offset(size.width * 0.7, size.height * 0.8);
    var secondEndPoint = Offset(size.width, size.height * 0.5);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    // Close the path
    path.lineTo(size.width, 0); // Top-right corner
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}