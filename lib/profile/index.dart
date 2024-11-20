import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/profile/functions/login.dart';
import 'package:app/calendar/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<Map<String, dynamic>> loginProvider =
    StateProvider<Map<String, dynamic>>((ref) => {
          "email": "",
          "password": "",
        });

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Center(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email:"),
              CustomInput(
                provider: loginProvider,
                providerKey: "email",
                hint: "Email",
              ),
              const SizedBox(height: 16),
              const Text("Email:"),
              CustomInput(
                provider: loginProvider,
                providerKey: "password",
                hint: "Adgangskode",
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: colorThemeState.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          login(
                            ref.read(loginProvider)['email'],
                            ref.read(loginProvider)['password'],
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorThemeState.secondaryFontColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
