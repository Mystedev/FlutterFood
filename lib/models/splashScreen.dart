import 'package:flutter/material.dart';
import 'package:flutter_food/screens/weekly_meals_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDotCenter = false;
  bool _isScalTheCircle = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationSequence();
    });
  }

  Future<void> _startAnimationSequence() async {
    setState(() {
      _isDotCenter = true;
    });

    await Future.delayed(const Duration(milliseconds: 520));
    if (!mounted) return;

    setState(() {
      _isScalTheCircle = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WeeklyMealsScreen(startDate: DateTime.now()),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) =>
            FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 82, 39),
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Center(
              child: AnimatedScale(
                duration: Duration(milliseconds: 600),
                curve: Cubic(0.58, -0.30, 0.365, 1),
                scale: _isScalTheCircle ? 10 : 1,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.surface,
                  child: Center(
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: _isScalTheCircle
                          ? colorScheme.surface
                          : Color.fromARGB(255, 14, 82, 39),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Cubic(.47, -1.26, .36, 1),
              left: (MediaQuery.of(context).size.width / 2) -
                  12 -
                  (_isDotCenter ? 0 : 80),
              child: CircleAvatar(radius: 12, backgroundColor: Colors.white),
            ),
            Positioned(
              bottom: 40,
              child: SizedBox(
                height: 48,
                width: 120,
                child: Center(
                  child: Text(
                    "Food",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
