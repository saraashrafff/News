class CategoryModel {
  String id;
  String name;
  String imageName;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageName,
  });
  static List<CategoryModel> categories = [
    CategoryModel(id: 'general', name: 'General', imageName: 'general'),
    CategoryModel(id: 'business', name: 'Business', imageName: 'business'),
    CategoryModel(id: 'sports', name: 'Sport', imageName: 'sport'),
    CategoryModel(
      id: 'entertainment',
      name: 'Entertainment',
      imageName: 'entertainment',
    ),
    CategoryModel(id: 'health', name: 'Health', imageName: 'health'),
    CategoryModel(id: 'science', name: 'Science', imageName: 'science'),
    CategoryModel(
      id: 'technology',
      name: 'Technology',
      imageName: 'technology',
    ),
  ];
}
