import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/model/utente.dart';

class PostWidget extends StatelessWidget {
  final Post posts;
  final Utente utente;
  const PostWidget({Key? key, required this.posts, required this.utente})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const defaultIcon =
        'https://firebasestorage.googleapis.com/v0/b/pinpointmvvm.appspot.com/o/Default%20Images%2FProfilePicture.png?alt=media&token=780391e3-37ee-4352-8367-f4c08b0f809d';
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(posts.imageUrl ?? defaultIcon),
                radius: 20,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    utente.username ?? 'Username',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '${posts.latitude} ${posts.longitude}',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Image.network(posts.imageUrl ?? defaultIcon),
            // Qui puoi inserire l'immagine dell'utente
            // utilizzando una delle seguenti opzioni:
            // - Image.network(url),
            // - Image.asset('assets/image.jpg'),
            // - Image.file(File('path/to/image.jpg')),
            // Assicurati di adattare le dimensioni dell'immagine
            // in base al riquadro del contenitore.
          ),
          const SizedBox(height: 8.0),
          Text(
            posts.description ?? 'Description',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
