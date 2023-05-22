import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/default_profile_image.jpg'),
                radius: 20,
              ),
              SizedBox(width: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Posizione',
                    style: TextStyle(fontSize: 14.0),
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
            child: Image.asset('assets/images/default_profile_image.jpg'),
            // Qui puoi inserire l'immagine dell'utente
            // utilizzando una delle seguenti opzioni:
            // - Image.network(url),
            // - Image.asset('assets/image.jpg'),
            // - Image.file(File('path/to/image.jpg')),
            // Assicurati di adattare le dimensioni dell'immagine
            // in base al riquadro del contenitore.
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Descrizione del post',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
