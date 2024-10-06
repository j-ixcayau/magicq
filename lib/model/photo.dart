class Photo {
  final int id;
  final String url;
  final int? pointId;
  final int? markerId;

  Photo({
    required this.id,
    required this.url,
    required this.pointId,
    required this.markerId,
  });

  // Custom fromJson method
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      url: json['url'] as String,
      pointId: null,
      markerId: null,
    );
  }

  // Custom toJson method
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'pointId': pointId,
      'markerId': markerId,
    };
  }
}
