import 'package:flutter/cupertino.dart';

/// ViewModel che gestisce la pagina che mostra la barra di navigazione
class BottomNavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Metodo che permette di cambiare la pagina di visualizzazione.
  /// [index] Indice della pagina da visualizzare
  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
