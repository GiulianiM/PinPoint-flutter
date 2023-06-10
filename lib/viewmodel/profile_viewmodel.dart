import 'dart:async';
import 'package:pinpoint/model/post.dart';
import 'package:pinpoint/model/utente.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:rxdart/rxdart.dart';

class ProfileViewModel {
  final DatabaseQueries _databaseQueries = DatabaseQueries();

  final BehaviorSubject<Utente> _utenteController = BehaviorSubject<Utente>();
  final StreamController<List<Post>> _postsController = StreamController<List<Post>>();
  final StreamController<int> _followerCountController = StreamController<int>();
  final StreamController<int> _followingCountController = StreamController<int>();
  final StreamController<int> _postCountController = StreamController<int>();

  Stream<Utente> get utenteStream => _utenteController.stream;
  Stream<List<Post>> get postsStream => _postsController.stream;
  Stream<int> get followerCountStream => _followerCountController.stream;
  Stream<int> get followingCountStream => _followingCountController.stream;
  Stream<int> get postCountStream => _postCountController.stream;

  void fetchData() async {
    try {
      final thatUser = await _databaseQueries.getCurrentUserInfoStream();
      thatUser.listen((user) {
        _utenteController.add(user);
        print('Utente: ${user.username}');
      });


      final thosePostsStream = await _databaseQueries.getAllMyPostsStream();
      thosePostsStream.listen((posts) {
        _postsController.add(posts);
      });

      final thatFollowerCountStream = await _databaseQueries.getFollowerCountStream();
      thatFollowerCountStream.listen((count) {
        _followerCountController.add(count);
      });

      final thatFollowingCountStream = await _databaseQueries.getFollowingCountStream();
      thatFollowingCountStream.listen((count) {
        _followingCountController.add(count);
      });

      final thatPostCountStream = await _databaseQueries.getPostCountStream();
      thatPostCountStream.listen((count) {
        _postCountController.add(count);
      });

    } catch (error) {
      print('Errore durante il recupero dei dati: $error');
    }
  }

  void dispose() {
    _utenteController.close();
    _postsController.close();
    _followerCountController.close();
    _followingCountController.close();
    _postCountController.close();
  }
}
