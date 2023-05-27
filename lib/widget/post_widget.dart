import 'package:flutter/material.dart';
import 'package:pinpoint/model/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

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
                backgroundImage: NetworkImage(post.userPic ?? defaultIcon),
                radius: 20,
              ),
              const SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.username ?? 'Username',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '${post.latitude} ${post.longitude}',
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
            child: Image.network(
              post.imageUrl ?? defaultIcon,
              fit: BoxFit.cover, // Adatta l'immagine al contenitore
              width: double.infinity, // Occupa tutta la larghezza disponibile
              height: 400.0
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            post.description ?? 'Description',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
