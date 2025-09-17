import 'package:app/global/classes/color_theme.dart';
import 'package:app/global/constants.dart';
import 'package:app/global/widgets/placeholder_image.dart';
import 'package:app/profile/classes/user_account.dart';
import 'package:app/profile/functions/get_user_account_info.dart';
import 'package:app/profile/functions/update_user_account_info.dart';
import 'package:app/profile/widgets/editable_text.dart';
import 'package:app/score_list/widgets/player_ranking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<UserAccount?> updatedUserInfo = StateProvider<UserAccount?>(
  (ref) => null,
);

FutureProvider<UserAccount> updateUserInfoProvider =
    FutureProvider<UserAccount>((ref) async {
      UserAccount userAccount = await getUserAccountInfo();
      ref.read(updatedUserInfo.notifier).state = userAccount;
      return userAccount;
    });

class ChangeInfoWidget extends ConsumerWidget {
  const ChangeInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureAsyncValue = ref.watch(updateUserInfoProvider);
    CustomColorTheme colorThemeState = ref.watch(colorThemeProvider);
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          UserAccount? updatedInfoState = ref.watch(updatedUserInfo);
          if (updatedInfoState != null) {
            return FloatingActionButton.extended(
              backgroundColor: colorThemeState.primaryColor,
              onPressed: () {
                updateUserAccountInfo(updatedInfoState);
                // Navigator.of(context).pop();
              },
              label: const Row(
                children: [
                  Icon(Icons.save, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Gem",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      backgroundColor: colorThemeState.backgroundColor,
      body: SafeArea(
        child: futureAsyncValue.when(
          data: (data) {
            data = ref.watch(updatedUserInfo) ?? data;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(
                            Icons.chevron_left,
                            size: 32,
                            color: colorThemeState.fontColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Brugerkonto",
                            style: TextStyle(
                              color: colorThemeState.fontColor.withValues(
                                alpha: 0.8,
                              ),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PlaceholderImage(),
                  ...{
                        {
                          "header": "Email",
                          "value": [data.email],
                        },
                        {
                          "header": "Navn",
                          "value": [data.name],
                        },
                        {"header": "Telefon", "value": data.phoneNumbers},
                        {
                          "header": "Gade",
                          "value": [data.street],
                        },
                        {
                          "header": "Postnummer",
                          "value": [data.postalCode],
                        },
                        {
                          "header": "By",
                          "value": [data.city],
                        },
                        {
                          "header": "Offentlig profil",
                          "value": ["${data.publicProfile}"],
                        },
                        {
                          "header": "Information om anbefalede turneringer",
                          "value": ["${data.newsletter}"],
                        },
                        {
                          "header": "Mail ved opdatering til turnering",
                          "value": ["${data.tournamentInfo}"],
                        },
                        {
                          "header": "Mail ved opdatering af rangliste",
                          "value": ["${data.rankingInfo}"],
                        },
                        {
                          "header": "Mail ved opdatering af holdkamp",
                          "value": ["${data.teamtournamentInfo}"],
                        },
                      }
                      .map(
                        (e) => EditableProfileText(
                          header: e['header'] as String,
                          value: e['value'] as List<String>,
                          onChanged: (value) =>
                              ref
                                  .read(updatedUserInfo.notifier)
                                  .state = data.copyWith(
                                email: (e['header'] as String) == "Email"
                                    ? (value)
                                    : null,
                                name: (e['header'] as String) == "Navn"
                                    ? (value)
                                    : null,
                                phoneNumbers:
                                    (e['header'] as String) == "Telefon"
                                    ? ref
                                          .read(updatedUserInfo.notifier)
                                          .state!
                                          .phoneNumbers
                                          .map((e) {
                                            if (value.isEmpty) {
                                              return e;
                                            }
                                            if (value.length > e.length) {
                                              return value.toString();
                                            }
                                            if (e.substring(0, value.length) ==
                                                value) {
                                              return value.toString();
                                            }
                                            return e.toString();
                                          })
                                          .toList()
                                    : null,
                                street: (e['header'] as String) == "Gade"
                                    ? (value)
                                    : null,
                                postalCode:
                                    (e['header'] as String) == "Postnummer"
                                    ? (value)
                                    : null,
                                city: (e['header'] as String) == "By"
                                    ? (value)
                                    : null,
                                publicProfile:
                                    (e['header'] as String) ==
                                        "Offentlig profil"
                                    ? (value)
                                    : null,
                                newsletter:
                                    (e['header'] as String) ==
                                        "Information om anbefalede turneringer"
                                    ? (value) ?? ["false"]
                                    : null,
                                tournamentInfo:
                                    (e['header'] as String) ==
                                        "Mail ved opdatering til turnering"
                                    ? (value) ?? ["false"]
                                    : null,
                                rankingInfo:
                                    (e['header'] as String) ==
                                        "Mail ved opdatering af rangliste"
                                    ? (value) ?? ["false"]
                                    : null,
                                teamtournamentInfo:
                                    (e['header'] as String) ==
                                        "Mail ved opdatering af holdkamp"
                                    ? (value) ?? ["false"]
                                    : null,
                              ),
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 80),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const CustomCircularProgressIndicator(),
        ),
      ),
    );
  }
}
