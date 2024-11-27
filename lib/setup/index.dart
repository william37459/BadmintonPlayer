import 'package:app/setup/functions/get_setup_values.dart';
import 'package:flutter/material.dart';

class SetupWidget extends StatefulWidget {
  const SetupWidget({super.key});

  @override
  State<SetupWidget> createState() => _SetupWidgetState();
}

class _SetupWidgetState extends State<SetupWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController progressController;
  late Animation<double> progress;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      upperBound: 1,
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    progressController = AnimationController(
      upperBound: 1,
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    progress = CurvedAnimation(
      parent: progressController,
      curve: Curves.decelerate, // Change the curve here
    );
  }

  @override
  void dispose() {
    controller.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSetupValues(),
      builder: (context, snapshot) {
        return Material(
          color: const Color(0xffDF2026),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: controller,
                child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.25,
                        child: Image.asset(
                          "assets/Foreground.png",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: progressController,
                builder: (context, widget) => Container(
                  width: progressController.value *
                      MediaQuery.of(context).size.width *
                      0.3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
