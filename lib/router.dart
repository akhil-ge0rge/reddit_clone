import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screen/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screen/community_screen.dart';
import 'package:reddit_clone/features/community/screen/create_community_screen.dart';
import 'package:reddit_clone/features/community/screen/edit_community.dart';
import 'package:reddit_clone/features/community/screen/mod_tools.dart';
import 'package:reddit_clone/features/home/screen/home_screen.dart';
import 'package:reddit_clone/features/posts/screen/add_post_type_screen.dart';
import 'package:reddit_clone/features/user_profile/screen/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screen/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (route) => MaterialPage(
        child: ModToolsScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/edit-community/:name': (routeData) => MaterialPage(
        child: EditCommunityScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/add-mods/:name': (routeData) => MaterialPage(
        child: AddModeratorsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/user-profile/:uid': (routeData) => MaterialPage(
        child: UserProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
        child: EditProfileScreen(
          uid: routeData.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (routeData) => MaterialPage(
        child: AddPostTypeScreen(
          type: routeData.pathParameters['type']!,
        ),
      ),
});
