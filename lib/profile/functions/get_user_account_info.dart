import 'package:app/global/constants.dart';
import 'package:app/profile/classes/user_account.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<UserAccount> getUserAccountInfo() async {
  http.Response response = await http.get(
    Uri.parse('https://www.badmintonplayer.dk/DBF/Bruger/RetProfil/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      "Cookie": 'ASP.NET_SessionId=$cookies',
    },
  );

  final document = html_parser.parse(response.body);

  if (document.querySelectorAll(".validationsummary").isEmpty) {
    return UserAccount.fromElement(
      document.getElementById("ctl00_ContentPlaceHolder1_UpdatePanel1"),
    );
  } else {
    throw Exception('Failed to load user account info');
  }
}
