import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/presentation/screens/my_article_screen.dart';
import 'package:ruang_sehat/features/home/screens/home_screen.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ruang_sehat/features/articles/providers/articles_providers.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  static const String routeName = '/bottom-navbar';

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  bool _isFirstLoad = true;
  List<Widget> _pages = [const HomeScreen(), const MyArticleScreen()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final articleProvider = context.read<ArticleProviders>();
      articleProvider.getArticles();
      articleProvider.getMyArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.hintText,
        currentIndex: _selectedIndex,
        iconSize: 20,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'My Article',
          ),
        ],
      ),
    );
  }
}
