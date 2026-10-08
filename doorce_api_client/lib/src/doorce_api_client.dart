import 'package:doorce_keycloak_token_handler/doorce_keycloak_token_handler.dart';
import 'package:http/http.dart' as http;

abstract class Api {
  String backendPath;
  
  final TokenAPI tokenAPI;

  Api({required this.backendPath, required this.tokenAPI});

  Future<Map<String,String>> getCommonHeaders() async {
    final token = await tokenAPI.getAccessToken();
    return {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getUpsertHeaders() async {
    final commonHeaders = await getCommonHeaders();
    return {
      ...commonHeaders,
      'Content-Type': 'application/json'
    };
  }

  Future<http.Response> httpGet(String urlPostfix) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.get(url, headers: await getCommonHeaders());
    if (response.statusCode == 401) {
      await tokenAPI.refresh();
      response = await http.get(url, headers: await getCommonHeaders());
    }
    return response;
  }

  Future<http.Response> httpPost(String urlPostfix, String? body) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.post(url, headers: await getUpsertHeaders(), body: body);
    if (response.statusCode == 401) {
      await tokenAPI.refresh();
      response = await http.post(url, headers: await getUpsertHeaders(), body: body);
    }
    return response;
  }

  Future<http.Response> httpDelete(String urlPostfix) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.delete(url, headers: await getCommonHeaders());
    if (response.statusCode == 401) {
      await tokenAPI.refresh();
      response = await http.delete(url, headers: await getCommonHeaders());
    }
    return response;
  }
}