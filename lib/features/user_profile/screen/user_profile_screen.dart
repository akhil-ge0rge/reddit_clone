import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });
  void navigateToEditUserProfile(
    BuildContext context,
  ) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (userProfile) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 200,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            userProfile.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20).copyWith(
                            bottom: 80,
                          ),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userProfile.profilePic),
                            radius: 35,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                              onPressed: () =>
                                  navigateToEditUserProfile(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Pallete.blackColor,
                              ),
                              child: const Text("Edit Profile")),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          "r/${userProfile.name}",
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "r/${userProfile.karma} Karma ",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ]),
                    ),
                  ),
                ];
              },
              body: ref.watch(getuserPostsProvider(uid)).when(
                    data: (data) => ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final post = data.elementAt(index);
                        return PostCard(post: post);
                      },
                    ),
                    error: (error, stackTrace) => ErrorWidget(error),
                    loading: () => const LoaderWidget(),
                  ),
            ),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
