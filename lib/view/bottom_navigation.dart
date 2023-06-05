import 'package:flutter/material.dart';
import 'package:pinpoint/view/post.dart';
import 'package:pinpoint/view/profile.dart';
import 'package:pinpoint/view/search.dart';
import 'package:provider/provider.dart';

import '../viewmodel/bottom_navigation_viewmodel.dart';
import 'feed.dart';
import 'homepage.dart';

/// Classe che mostra la bottom navigation bar per navigare tra le varie pagine dell'applicazione
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final BottomNavigationViewModel _viewModel = BottomNavigationViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationViewModel>(
      create: (_) => _viewModel,
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Consumer<BottomNavigationViewModel>(
            builder: (context, viewModel, _) {
              return IndexedStack(
                index: viewModel.currentIndex,
                children: [
                  Homepage(),
                  Search(),
                  Post(),
                  Feed(),
                  Profile(),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Consumer<BottomNavigationViewModel>(
          builder: (context, viewModel, _) {
            return BottomNavigationBar(
              selectedItemColor: Colors.deepPurple,
              unselectedItemColor: Colors.grey,
              currentIndex: viewModel.currentIndex,
              onTap: viewModel.changeTab,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box),
                  label: 'Post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.feed),
                  label: 'Feed',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}




