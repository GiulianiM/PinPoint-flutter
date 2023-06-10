import 'package:flutter/material.dart';
import 'package:pinpoint/widget/post_widget.dart';

import '../model/post.dart';
import '../model/utente.dart';
import '../utils/constants.dart';
import '../viewmodel/profile_viewmodel.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
    _viewModel.fetchData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            StreamBuilder<Utente>(
              stream: _viewModel.utenteStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final utente = snapshot.data!;
                  return Text(
                    utente.username!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
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
                  StreamBuilder<String>(
                    stream: _viewModel.utenteStream.map((utente) => utente.image ?? Constants.defaultIcon),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final image = snapshot.data!;
                        return CircleAvatar(
                          backgroundImage: NetworkImage(image),
                          radius: 50,
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(Constants.defaultIcon),
                          radius: 50,
                        );
                      }
                    },
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
                                StreamBuilder<int>(
                                  stream: _viewModel.postCountStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final count = snapshot.data!;
                                      return Text(
                                        count.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
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
                                StreamBuilder<int>(
                                  stream: _viewModel.followerCountStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final count = snapshot.data!;
                                      return Text(
                                        count.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
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
                                StreamBuilder<int>(
                                  stream: _viewModel.followingCountStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final count = snapshot.data!;
                                      return Text(
                                        count.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
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
              child: StreamBuilder<Utente>(
                stream: _viewModel.utenteStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final utente = snapshot.data!;
                    return Text(
                      utente.fullname ?? 'Nome Cognome',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: StreamBuilder<Utente>(
                stream: _viewModel.utenteStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final utente = snapshot.data!;
                    return Text(
                      utente.bio ?? 'Bio',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Post>>(
              stream: _viewModel.postsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final posts = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostWidget(post: posts[index], isProfile: true);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
