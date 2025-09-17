import 'package:app/global/classes/user.dart';
import 'package:app/global/constants.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

Future<User> getUserInfo() async {
  http.Response response = await http.get(
    Uri.parse('https://badmintonplayer.dk/DBF/Bruger/RetProfil/'),
    headers: {
      "Cookie": 'ASP.NET_SessionId=$cookies',
      "Accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "Accept-Encoding": "gzip, deflate, br, zstd",
      "Accept-Language": "da-DK,da;q=0.9,en-DK;q=0.8,en;q=0.7,en-US;q=0.6",
      "Cache-Control": "max-age=0",
      "Content-Type": "application/x-www-form-urlencoded",
      "Origin": "https://badmintonplayer.dk",
      "Priority": "u=0, i",
      "Referer": "https://badmintonplayer.dk/DBF/",
      "Sec-Ch-Ua":
          "\"Google Chrome\";v=\"129\", \"Not=A?Brand\";v=\"8\", \"Chromium\";v=\"129\"",
      "Sec-Ch-Ua-Mobile": "?0",
      "Sec-Ch-Ua-Platform": "\"macOS\"",
      "Sec-Fetch-Dest": "document",
      "Sec-Fetch-Mode": "navigate",
      "Sec-Fetch-Site": "same-origin",
      "Sec-Fetch-User": "?1",
      "Upgrade-Insecure-Requests": "1",
      "User-Agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
    },
  );

  Document document = html_parser.parse(response.body);

  String email =
      document.querySelector("#ctl00_ContentPlaceHolder1_LabelEmail")?.text ??
      "";
  String name =
      document
          .querySelector("#ctl00_ContentPlaceHolder1_TextBoxName")
          ?.attributes['value'] ??
      "";
  String telephone =
      document
          .querySelector("#ctl00_ContentPlaceHolder1_TextBoxPhone")
          ?.attributes['value'] ??
      "";
  String street =
      document
          .querySelector("#ctl00_ContentPlaceHolder1_TextBoxStreet")
          ?.attributes['value'] ??
      "";
  String postalCode =
      document
          .querySelector("#ctl00_ContentPlaceHolder1_TextBoxPostalCode")
          ?.attributes['value'] ??
      "";
  String town =
      document
          .querySelector("#ctl00_ContentPlaceHolder1_TextBoxCity")
          ?.attributes['value'] ??
      "";

  return User(
    email: email,
    name: name,
    telephone: telephone,
    street: street,
    postalCode: postalCode,
    town: town,
  );
}
