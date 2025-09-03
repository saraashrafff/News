import 'package:news/sources/data/data_sources/sources_data_source.dart';
import 'package:news/sources/data/models/source.dart';

class SourcesFirebaseDataSource implements SourcesDataSource {
  @override
  Future<List<Source>> getSources(String categoryId) async {
    //Firebase Logic
    return [];
  }
}
