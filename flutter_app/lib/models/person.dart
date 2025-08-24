class Person {
  final int id;
  final String fullName;
  final String? title;
  final String? bio;
  final String? imageUrl;

  Person({required this.id, required this.fullName, this.title, this.bio, this.imageUrl});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int,
    fullName: json['full_name'] as String,
    title: json['title'] as String?,
    bio: json['bio'] as String?,
    imageUrl: json['image_url'] as String?,
  );
}
