import 'package:app/global/classes/player_score.dart';
import 'package:app/score_list/widgets/player_ranking.dart';
import 'package:flutter/material.dart';

class RankingList extends StatelessWidget {
  final List<PlayerScore> playerScoreList;

  const RankingList({
    super.key,
    required this.playerScoreList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playerScoreList.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) => PlayerRanking(
        playerScore: playerScoreList[index],
      ),
    );
  }
}
