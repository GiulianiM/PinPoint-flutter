import 'package:flutter/material.dart';
import 'package:pinpoint/model/utente.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/widget/post_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DatabaseQueries databaseQueries = DatabaseQueries();
  int followerCount = 0;
  int followingCount = 0;
  int postCount = 0;
  Utente utente = Utente();
  List<Post> posts = <Post>[];
  final String defaultIcon =
      'https://firebasestorage.googleapis.com/v0/b/pinpointmvvm.appspot.com/o/Default%20Images%2FProfilePicture.png?alt=media&token=780391e3-37ee-4352-8367-f4c08b0f809d';

  @override
  void initState() {
    databaseQueries.getCurrentUserInfo().then((thatUser) {
      setState(() {
        utente = thatUser;
      });

      databaseQueries.getAllMinePosts().then((thosePosts) {
        setState(() {
          posts = thosePosts;
        });
      });
    });

    databaseQueries.getFollowerCount().then((thatNuber) => setState(() {
      followerCount = thatNuber;
    }));

    databaseQueries.getFollowingCount().then((thatNuber) => setState(() {
      followingCount = thatNuber;
    }));

    databaseQueries.getPostCount().then((thatNuber) => setState(() {
      postCount = thatNuber;
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              utente.username ?? 'Username',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Azione per aprire le impostazioni
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    // Immagine del profilo
                    backgroundImage: NetworkImage(utente.image ?? defaultIcon),
                    radius: 50,
                  ),
                  const SizedBox(width: 50),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  postCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Post',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  followerCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Followers',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  followingCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Following',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Azione per editare il profilo
                          },
                          child: const Text('Modifica profilo'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                utente.fullname ?? 'Nome Cognome',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                utente.bio ?? 'Bio',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostWidget(post: posts[index], isProfile: true);
              },

            ),
          ],
        ),
      ),
    );
  }
}
