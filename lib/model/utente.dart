/// Modello per la gestione degli utenti

class Utente {
  String? bio;
  String? email;
  String? fullname;
  String? image;
  String? latitude;
  String? longitude;
  String? uid;
  String? username;

  Utente({
    this.username,
    this.fullname,
    this.image,
    this.bio,
    this.email,
    this.latitude,
    this.longitude,
    this.uid,
  });

  factory Utente.fromMap(Map<dynamic, dynamic> data) {
    return Utente(
      username: data['username'] as String?,
      fullname: data['fullname'] as String?,
      image: data['image'] as String?,
      bio: data['bio'] as String?,
      email: data['email'] as String?,
      latitude: data['latitude'] as String?,
      longitude: data['longitude'] as String?,
      uid: data['uid'] as String?,
    );
  }

}
