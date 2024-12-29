class Book {
  final int? id;
  final String title;
  final String? photo;
  final String author;
  final String description;
  final int availableCopies;
  final int categoryId; // Representing the category ID as it's a foreign key

  Book({
    this.id,
    required this.title,
    this.photo,
    required this.author,
    required this.description,
    required this.availableCopies,
    required this.categoryId,
  });

  // Factory constructor to create a Book object from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      photo: json['photo'],
      author: json['author'],
      description: json['description'],
      availableCopies: json['availableCopies'],
      categoryId: json['category']['id'],  // Assuming category is nested in the JSON response
    );
  }

  // Method to convert a Book object to JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'photo': photo,
      'author': author,
      'description': description,
      'availableCopies': availableCopies,
      'category': {'id': categoryId},  // Assuming we're passing category ID for the relationship
    };
  }
}
