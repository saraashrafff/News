import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/shared/api_constants.dart';
import 'package:news/sources/data/models/sources_response.dart';

class SourcesDataSource {
  Future<SourcesResponse> getSources(String categoryId) async {
    Uri uri = Uri.https(APIConstants.baseURL, APIConstants.sourcesEndPoint, {
      'apiKey': APIConstants.apiKey,
      'category': categoryId,
    });
    http.Response response = await http.get(uri);
    print("🔍 API Response: ${response.body}");

    Map<String, dynamic> json = jsonDecode(response.body);
    return SourcesResponse.fromJson(json);
  }
}
