import 'dart:convert';
import 'package:app/profile/classes/user_account.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

Future<bool> updateUserAccountInfo(UserAccount userAccount) async {
  var test2 = {
    "__EVENTTARGET": "",
    "__EVENTARGUMENT": "",
    "__LASTFOCUS": "",
    "__VIEWSTATEGENERATOR": "BAD805F8",
    "ctl00\$ContentPlaceHolder1\$PopupPanelEmail\$State": "",
    "ctl00\$ContentPlaceHolder1\$TextBoxEmail": "williamdam7%40gmail.com",
    "ctl00\$ContentPlaceHolder1\$PopupPanelPassword\$State": "",
    "ctl00\$ContentPlaceHolder1\$TextBoxPassword": "juu57ytw",
    "ctl00\$ContentPlaceHolder1\$TextBoxRepeatPassword": "",
    "ctl00\$ContentPlaceHolder1\$TextBoxName": "William Dam 123",
    "ctl00\$ContentPlaceHolder1\$TextBoxPhone": "40837828 _ 27770105",
    "ctl00\$ContentPlaceHolder1\$TextBoxStreet": "Rosenholmvej12 30",
    "ctl00\$ContentPlaceHolder1\$TextBoxPostalCode": "89230 N%C3%98",
    "ctl00\$ContentPlaceHolder1\$TextBoxCity": "Randers1",
    "HiddenSelectedPlayerID1": "",
    "HiddenSelectedPlayerNumber1": "",
    "HiddenSelectedPlayerName1": "",
    "HiddenSelectPlayerSelectedClubID1": "",
    "HiddenSelectPlayerSelectedClubName1": "",
    "HiddenSelectPlayerGender1": "",
    "SearchPlayerName1": "",
    "ctl00\$ContentPlaceHolder1\$EditPlayerUserMulti\$SelectPlayer1\$SearchPlayer1\$SelectClubDropDown1\$TextBoxName":
        "Vejgaard",
    "ctl00\$ContentPlaceHolder1\$EditPlayerUserMulti\$SelectPlayer1\$SearchPlayer1\$SelectClubDropDown1\$HiddenFieldID":
        "1564",
    "ctl00\$ContentPlaceHolder1\$EditPlayerUserMulti\$SelectPlayer1\$SearchPlayer1\$SelectClubDropDown1\$TextboxSelectController1\$HiddenField1":
        "",
    "SearchPlayerPlayerID1": "",
    "SearchPlayerGender1": "",
    "SearchPlayerAgeGroup1": "",
    "__ASYNCPOST": "true",
    "ctl00\$ContentPlaceHolder1\$ButtonSave": "Gem",
  };

  String body = json.encode(test2);

  http.Response response = await http.post(
    Uri.parse("https://www.badmintonplayer.dk/DBF/Bruger/RetProfil/"),

    headers: {
      "User-Agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:142.0) Gecko/20100101 Firefox/142.0",
      "Accept": "*/*",
      "Accept-Language": "en-GB,en;q=0.5",
      "X-Requested-With": "XMLHttpRequest",
      "X-MicrosoftAjax": "Delta=true",
      "Cache-Control": "no-cache",
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
      "Sec-Fetch-Dest": "empty",
      "Sec-Fetch-Mode": "cors",
      "Sec-Fetch-Site": "same-origin",
      "Priority": "u=0",
      "Cookie":
          "email=; password=; ASP.NET_SessionId=ochrk4ctqit0p5wp1yb3brdy; CookieConsent={stamp:%2728xyLITERyMloGCPfclyRC6BkhyST9xn9zQ3kK9Ab4AaVABjIwpX5w==%27%2Cnecessary:true%2Cpreferences:false%2Cstatistics:false%2Cmarketing:false%2Cmethod:%27explicit%27%2Cver:1%2Cutc:1757948109464%2Cregion:%27dk%27}; _ga=GA1.2.286215983.1757948400; _gid=GA1.2.110108833.1757948400",
    },
    body: body,
  );

  Document document = html_parser.parse(response.body);

  print(response.statusCode);

  if (document.querySelectorAll(".validationsummary").isEmpty &&
      response.statusCode == 200) {
    print("Sucess");
    return true;
  }
  print("NEJ");
  return false;
}
