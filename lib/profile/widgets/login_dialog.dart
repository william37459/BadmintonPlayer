import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/user.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/widgets/custom_input.dart';
import 'package:app/profile/functions/get_user_info.dart';
import 'package:app/profile/functions/login.dart';
import 'package:app/profile/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginDialog extends ConsumerWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    bool? keepLoggedInState = ref.watch(keepLoggedIn);
    LoginState isLoggedInState = ref.watch(isLoggedInProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(4),
          color: colorThemeState.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Log ind",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: colorThemeState.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Text(
                      "Brug dit badmintonplayer log ind her for at se din profil",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomContainer(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: colorThemeState.backgroundColor,
                  child: CustomInput(
                    provider: loginProvider,
                    providerKey: "email",
                    hint: "Email",
                  ),
                ),
                const SizedBox(height: 16),
                CustomContainer(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(12),
                  backgroundColor: colorThemeState.backgroundColor,
                  child: CustomInput(
                    obscureText: true,
                    provider: loginProvider,
                    providerKey: "password",
                    hint: "Adgangskode",
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: keepLoggedInState,
                      onChanged: (value) {
                        ref.read(keepLoggedIn.notifier).state = value ?? false;
                      },
                      visualDensity: VisualDensity.compact,
                      activeColor: colorThemeState.primaryColor,
                    ),
                    GestureDetector(
                      onTap: () => ref.read(keepLoggedIn.notifier).state = !ref
                          .read(keepLoggedIn.notifier)
                          .state,
                      child: Text(
                        "Hold mig logget ind",
                        style: TextStyle(
                          fontSize: 14,
                          color: colorThemeState.fontColor.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoggedInState == LoginState.wrongCredentials)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red.withValues(alpha: 0.8),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Du har indtastet forkert email eller adgangskode",
                          style: TextStyle(
                            color: Colors.red.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: colorThemeState.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                        child: InkWell(
                          onTap: () {
                            NavigatorState navigator = Navigator.of(context);
                            login(
                              ref.read(loginProvider)['email'].toLowerCase(),
                              ref.read(loginProvider)['password'],
                              ref.read(keepLoggedIn),
                            ).then((value) {
                              ref
                                  .read(isLoggedInProvider.notifier)
                                  .state = value
                                  ? LoginState.isLoggedIn
                                  : LoginState.wrongCredentials;
                              if (value) {
                                getUserInfo().then(
                                  (User user) =>
                                      ref.read(userProvider.notifier).state =
                                          user,
                                );
                              }
                              navigator.pop();
                            });
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              "Log ind",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorThemeState.secondaryFontColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
