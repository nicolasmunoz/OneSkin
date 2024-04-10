import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:claude_dart_flutter/claude_dart_flutter.dart' as claude;

class HttpService {
  static Future<http.Response> postImage(XFile image) async {
    try {
      var uri = Uri.parse(
          'https://3c09-12-162-124-34.ngrok-free.app/analyze/picture');
      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes(
            "file", await image.readAsBytes(),
            filename: image.path, contentType: MediaType("image", "jpg")));
      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      return http.Response('', 500);
    }
  }

  static Future<claude.Response> postClaude(claude.Request request) async {
    claude.ClaudeService claudeService = claude.ClaudeService("API_KEY");
    claude.Response response =
        await claudeService.sendRequest(request: request);

    return response;
  }

  static Future<http.Response> post(String url, dynamic body) async {
    return http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
  }
}
