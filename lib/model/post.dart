class Post {
  String? postId;
  String? userId;
  String? latitude;
  String? longitude;
  String? description;
  String? imageUrl;
  String? date;
  String? userPic;
  String? username;

  Post({
    this.postId,
    this.userId,
    this.latitude,
    this.longitude,
    this.description,
    this.imageUrl,
    this.date,
    this.username,
    this.userPic
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'imageUrl': imageUrl,
      'date': date,
    };
  }
}
