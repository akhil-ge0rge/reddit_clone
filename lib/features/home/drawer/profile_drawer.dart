import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/user-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "u/${user.name}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Pallete.greyColor,
            ),
            ListTile(
              onTap: () => navigateToUserProfile(context, user.uid),
              title: const Text("My Profile"),
              leading: const Icon(Icons.person),
            ),
            ListTile(
              onTap: () => logOut(ref),
              title: const Text("Log Out"),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
            ),
            Switch.adaptive(
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
