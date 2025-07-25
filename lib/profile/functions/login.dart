import 'package:app/global/constants.dart';
import 'package:http/http.dart' as http;

Future<bool> login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) return false;
  http.Response sessionCookieRequest = await http.post(
    Uri.parse("https://badmintonplayer.dk/DBF/"),
  );

  String sessionCookie = sessionCookieRequest.headers['set-cookie']
          ?.replaceAll("ASP.NET_SessionId=", "")
          .replaceAll(RegExp("[;].*"), "") ??
      "";

  cookies = sessionCookie;

  http.Response response = await http.post(
    Uri.parse('https://badmintonplayer.dk/DBF/'),
    headers: {
      "Cookie": 'ASP.NET_SessionId=$cookies',
    },
    body: {
      "__EVENTTARGET": "",
      "ctl00\$TextBoxLoginEmail": email,
      "ctl00\$TextBoxLoginPassword": password,
      "ctl00\$ButtonLogin": "Log ind",
    },
  );

  response = await http.get(
    Uri.parse('https://badmintonplayer.dk/'),
    headers: {
      "Cookie": 'ASP.NET_SessionId=$cookies',
    },
  );

  return response.body.contains(email);
}
