import 'package:news/sources/data/models/source.dart';

class SourcesResponse {
  String? status;
  List<Source>? sources;

  SourcesResponse({this.status, this.sources});

  factory SourcesResponse.fromJson(Map<String, dynamic> json) {
    print("📥 JSON اللي جالي: $json"); // يطبع كل الـ response

    final sourcesList = (json['sources'] as List<dynamic>?)
        ?.map((e) => Source.fromJson(e as Map<String, dynamic>))
        .toList();

    print("📤 عدد الـ sources اللي اتعملهم parse: ${sourcesList?.length}");

    return SourcesResponse(
      status: json['status'] as String?,
      sources: sourcesList,
    );
  }
}
