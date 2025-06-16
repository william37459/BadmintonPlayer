import 'package:app/calendar/widgets/custom_input.dart';
import 'package:app/global/widgets/custom_container.dart';
import 'package:app/team_tournament/index.dart';
import 'package:flutter/material.dart';

class SearchByNumber extends StatelessWidget {
  const SearchByNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomContainer(
            child: CustomInput(
              hint: "Søg efter kampnummer",
              provider: teamTournamentFilterProvider,
              providerKey: "matchNumber",
              inputType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
