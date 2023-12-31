import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawer/profile_drawer.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigateToAddPost(BuildContext context) {
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: false,
        leading: Builder(builder: (ctx) {
          return IconButton(
            onPressed: () => displayDrawer(ctx),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () => navigateToAddPost(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          Builder(builder: (ctx) {
            return IconButton(
              onPressed: () => displayEndDrawer(ctx),
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
            );
          })
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: isGuest ? null : ProfileDrawer(),
      bottomNavigationBar: isGuest || kIsWeb
          ? null
          : CupertinoTabBar(
              activeColor: currentTheme.iconTheme.color,
              backgroundColor: currentTheme.backgroundColor,
              onTap: onPageChange,
              currentIndex: _page,
              items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add),
                    label: '',
                  ),
                ]),
    );
  }
}
