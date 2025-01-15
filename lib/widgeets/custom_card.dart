import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CustomCard extends StatefulWidget {
  String? currentTime;
  String? currentDate;
  final Widget? currentWeather;
  CustomCard({
    Key? key,
    required this.currentTime,
    required this.currentDate,
    required this.currentWeather,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  String? currentTime;
  String? currentDate;
  String? currentWeather;
  bool isHovered = false;
  String getDayOrNightIcon() {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 18) {
      // Daytime (6 AM to 6 PM)
      return "☀️"; // Sun icon
    } else {
      // Nighttime
      return "🌙"; // Moon icon
    }
  }
  LinearGradient getGradientForTimeOfDay() {
    final now = DateTime.now();
    if (now.hour >= 6 && now.hour < 18) {
      // Daytime Gradient
      return LinearGradient(
        colors: [Color(0xFFCC5500), Color(0xFFFFA500)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    } else {
      // Nighttime Gradient
      return const LinearGradient(
        colors: [
          Color.fromRGBO(20, 30, 48, 1),
          Color.fromRGBO(36, 59, 85, 1),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 400,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: isHovered
              ? [
            const BoxShadow(
              color: Colors.black,
              offset: Offset(5, 10),
              blurRadius: 50,
            ),
            const BoxShadow(
              color: Colors.black,
              offset: Offset(-5, 0),
              blurRadius: 250,
            ),
          ]
              : [
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              offset: Offset(5, 10),
              blurRadius: 50,
            ),
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              offset: Offset(-5, 0),
              blurRadius: 250,
            ),
          ],
          gradient: getGradientForTimeOfDay(),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.currentTime ?? '', // Example Time
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gill Sans',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        widget.currentDate ?? '', // Example Date
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gill Sans',
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 130,
                      ),
                     if(widget.currentWeather!=null) widget.currentWeather!,
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: isHovered ? 23 : 20,
                  color: Colors.white,
                  fontFamily: 'Gill Sans',
                ),
                child: Text(getDayOrNightIcon(),style: TextStyle(fontSize: 60),), // Dynamic Sun/Moon Icon // Moon Icon
              ),
            ),
          ],
        ),
      ),
    );
  }
}