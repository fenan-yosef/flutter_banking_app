import 'package:flutter/material.dart';

enum NavTab { wallet, analytics, transact, profile }

/// Controller managing active bottom navigation index.
class NavigationController extends ChangeNotifier {
  NavTab _activeTab = NavTab.wallet;

  NavTab get activeTab => _activeTab;

  void setTab(NavTab tab) {
    if (_activeTab == tab) return;
    _activeTab = tab;
    notifyListeners();
  }
}
