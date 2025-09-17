import 'dart:ui';

import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/user.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/global/widgets/custom_input.dart';
import 'package:app/profile/functions/get_user_info.dart';
import 'package:app/profile/functions/login.dart';
import 'package:app/profile/pages/change_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

StateProvider<bool?> isLoggedInProvider = StateProvider<bool?>((ref) => null);

StateProvider<bool> keepLoggedIn = StateProvider<bool>((ref) => false);

StateProvider<User> userProvider = StateProvider<User>(
  (ref) => User(
    email: "",
    name: "",
    telephone: "",
    street: "",
    postalCode: "",
    town: "",
  ),
);

List<String> menus = [
  "Brugerkonto",
  "Mine spillere",
  "Mine betalinger",
  "Mine tilmeldinger",
  "Opret klubskifte",
  "Klubskifter",
  "Opret nyt BadmintonID",
];

StateProvider<Map<String, dynamic>> loginProvider =
    StateProvider<Map<String, dynamic>>((ref) => {"email": "", "password": ""});

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    bool? isLoggedInState = ref.watch(isLoggedInProvider);
    User userProviderState = ref.watch(userProvider);
    bool? keepLoggedInState = ref.watch(keepLoggedIn);

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: isLoggedInState ?? false
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Profil",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 8,
                        children: [
                          const SizedBox(height: 16),
                          CustomContainer(
                            margin: const EdgeInsets.only(bottom: 8),
                            borderRadius: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userProviderState.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      userProviderState.email,
                                      style: TextStyle(
                                        color: colorThemeState.fontColor
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          for (String menu in menus)
                            CustomContainer(
                              onTap: () {
                                ref.invalidate(updateUserInfoProvider);
                                Navigator.of(context).pushNamed(
                                  "/Profile/${menu.replaceAll(" ", "")}",
                                );
                              },
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              borderRadius: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(menu),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey[400] ?? Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          CustomContainer(
                            onTap: () async {
                              final Email email = Email(
                                body: '',
                                subject: 'Badmintonplayer app - ny feature',
                                recipients: ['williamdam7@gmail.com'],
                                isHTML: false,
                              );

                              try {
                                await FlutterEmailSender.send(email);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            },
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Foreslå en feature!"),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400] ?? Colors.grey,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 64),
                          CustomContainer(
                            onTap: () async {
                              SharedPreferencesAsync prefs =
                                  SharedPreferencesAsync();
                              await prefs.remove('email');
                              await prefs.remove('password');
                              ref.read(isLoggedInProvider.notifier).state =
                                  null;
                              ref.read(loginProvider.notifier).state = {
                                "email": "",
                                "password": "",
                              };
                              ref.read(userProvider.notifier).state = User(
                                email: "",
                                name: "",
                                telephone: "",
                                street: "",
                                postalCode: "",
                                town: "",
                              );
                            },
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Log ud",
                                  style: TextStyle(color: Colors.red),
                                ),
                                Icon(Icons.logout, color: Colors.red),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoggedInState != true)
          Material(
            color: Colors.black26,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: colorThemeState.secondaryFontColor,
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
                                ref.read(keepLoggedIn.notifier).state =
                                    value ?? false;
                              },
                              visualDensity: VisualDensity.compact,
                              activeColor: colorThemeState.primaryColor,
                            ),
                            Text(
                              "Hold mig logget ind",
                              style: TextStyle(
                                fontSize: 14,
                                color: colorThemeState.fontColor.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isLoggedInState == false)
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
                                    login(
                                      ref
                                          .read(loginProvider)['email']
                                          .toLowerCase(),
                                      ref.read(loginProvider)['password'],
                                      ref.read(keepLoggedIn),
                                    ).then((value) {
                                      ref
                                              .read(isLoggedInProvider.notifier)
                                              .state =
                                          value;
                                      if (value) {
                                        getUserInfo().then(
                                          (User user) =>
                                              ref
                                                      .read(
                                                        userProvider.notifier,
                                                      )
                                                      .state =
                                                  user,
                                        );
                                      }
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
                                        color:
                                            colorThemeState.secondaryFontColor,
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
            ),
          ),
      ],
    );
  }
}
