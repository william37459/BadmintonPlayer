import 'dart:ui';

import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/classes/user.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/profile/classes/settings_link.dart';
import 'package:app/profile/pages/change_info.dart';
import 'package:app/profile/widgets/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginState { isLoggedIn, isLoggedOut, wrongCredentials }

StateProvider<LoginState> isLoggedInProvider = StateProvider<LoginState>(
  (ref) => LoginState.isLoggedOut,
);

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
List<SettingsLink> menus = [
  SettingsLink(
    title: "Brugerkonto",
    link: "/Profile/Brugerkonto",
    icon: Icons.person,
  ),
  SettingsLink(
    title: "Mine spillere",
    link: "/Profile/MineSpillere",
    icon: Icons.sports_basketball,
  ),
  SettingsLink(
    title: "Mine betalinger",
    link: "/Profile/MineBetalinger",
    icon: Icons.payment,
  ),
  SettingsLink(
    title: "Mine tilmeldinger",
    link: "/Profile/MineTilmeldinger",
    icon: Icons.list_alt,
  ),
  SettingsLink(
    title: "Opret klubskifte",
    link: "/Profile/OpretKlubskifte",
    icon: Icons.swap_horiz,
  ),
  SettingsLink(
    title: "Klubskifter",
    link: "/Profile/Klubskifter",
    icon: Icons.group,
  ),
  SettingsLink(
    title: "Opret nyt BadmintonID",
    link: "/Profile/OpretNytBadmintonID",
    icon: Icons.badge,
  ),
];

StateProvider<Map<String, dynamic>> loginProvider =
    StateProvider<Map<String, dynamic>>((ref) => {"email": "", "password": ""});

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    LoginState isLoggedInState = ref.watch(isLoggedInProvider);
    User userProviderState = ref.watch(userProvider);

    return SafeArea(
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
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                      onTap: () {
                        if (isLoggedInState != LoginState.isLoggedIn) {
                          showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => const LoginDialog(),
                          );
                        }
                      },
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
                                isLoggedInState == LoginState.isLoggedIn
                                    ? userProviderState.name
                                    : "Tryk her for at logge ind",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                isLoggedInState == LoginState.isLoggedIn
                                    ? userProviderState.email
                                    : "Tryk her for at logge ind",
                                style: TextStyle(
                                  color: colorThemeState.fontColor.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      onTap: () async {
                        Navigator.of(context).pushNamed("/Profile/Settings");
                      },
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      borderRadius: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Indstillinger",
                            style: TextStyle(color: colorThemeState.fontColor),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: colorThemeState.fontColor.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      onTap: isLoggedInState != LoginState.isLoggedIn
                          ? () {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) => const LoginDialog(),
                              );
                            }
                          : null,
                      borderRadius: 0,
                      child: AbsorbPointer(
                        absorbing: isLoggedInState != LoginState.isLoggedIn,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (SettingsLink menu in menus)
                              InkWell(
                                onTap: () {
                                  ref.invalidate(updateUserInfoProvider);
                                  Navigator.of(context).pushNamed(menu.link);
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(menu.title),
                                        Icon(
                                          Icons.chevron_right,
                                          color: colorThemeState.fontColor
                                              .withValues(alpha: 0.2),
                                        ),
                                      ],
                                    ),
                                    if (menus.indexOf(menu) != menus.length - 1)
                                      Divider(
                                        color: colorThemeState.fontColor
                                            .withValues(alpha: 0.1),
                                        height: 16,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 64),
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      borderRadius: 0,
                      margin: const EdgeInsets.all(0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Foreslå en feature!",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.green),
                        ],
                      ),
                    ),
                    CustomContainer(
                      onTap: () async {
                        SharedPreferencesAsync prefs = SharedPreferencesAsync();
                        await prefs.remove('email');
                        await prefs.remove('password');
                        ref.read(isLoggedInProvider.notifier).state =
                            LoginState.isLoggedOut;
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
                      borderRadius: 0,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Log ud", style: TextStyle(color: Colors.red)),
                          Icon(Icons.logout, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final packageInfo = snapshot.data!;
                  return Center(
                    child: Text(
                      "Version ${packageInfo.version} (${packageInfo.buildNumber})",
                      style: TextStyle(
                        color: colorThemeState.fontColor.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const Center(child: Text("Version loading..."));
              },
            ),
          ],
        ),
      ),
    );
  }
}
