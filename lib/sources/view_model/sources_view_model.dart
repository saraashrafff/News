import 'package:flutter/material.dart';
import 'package:news/sources/data/data_sources/sources_data_source.dart';
import 'package:news/sources/data/models/source.dart';
import 'package:news/sources/data/models/sources_response.dart';

class SourcesViewModel with ChangeNotifier {
  SourcesDataSource dataSource = SourcesDataSource();
  List<Source> sources = [];
  String? errorMessage;
  bool isLoading = false;

  Future<void> getSources(String categoryId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); // تحديث UI فورًا للـ loading

    try {
      SourcesResponse response = await dataSource.getSources(categoryId);
      print("✅ Sources in ViewModel: ${response.sources?.length}");

      if (response.status == 'ok' && response.sources != null) {
        sources = response.sources!;
      } else {
        errorMessage = 'Failed to get sources';
      }
    } catch (error) {
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners(); // تحديث UI بعد انتهاء الـ fetch
  }
}
