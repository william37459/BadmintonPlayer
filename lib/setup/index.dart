import 'package:app/setup/functions/get_setup_values.dart';
import 'package:flutter/material.dart';

class SetupWidget extends StatelessWidget {
  const SetupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSetupValues(),
      builder: (context, snapshot) {
        return Container();
      },
    );
  }
}
