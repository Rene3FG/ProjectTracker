class Project {
  final String id;
  final String name;
  final String description;
  final int progress;
  final String? imageUrl;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    this.imageUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      progress: int.parse(json['progress'].toString()),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'progress': progress,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }
}
