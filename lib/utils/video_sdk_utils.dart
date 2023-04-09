import 'dart:convert';
import 'package:http/http.dart' as http;

const String token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJkMmM5MGM1NC0zYjMzLTQxMDctYTE3MC0wOTNmMzVlYTg3M2UiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4MTA2NDU0NywiZXhwIjoxODM4ODUyNTQ3fQ.Gb78MEK9o4ea81j1s-p3u5Jecg7P5qkxzNwKVMeilKs';

class VideoSDKUtils {
  static Future<String> createMeeting() async {
    final http.Response httpResponse = await http.post(Uri.parse('https://api.videosdk.live/v2/rooms'), headers: {'Authorization': token});
    return json.decode(httpResponse.body)['roomId'];
  }
}
