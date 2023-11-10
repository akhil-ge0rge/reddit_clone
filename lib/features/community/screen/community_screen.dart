import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/post_card.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/mod-tools/$name");
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(context, community);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider)!.uid;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
            data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "r/${community.name}",
                              style: const TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                            community.mods.contains(userId)
                                ? OutlinedButton(
                                    onPressed: () =>
                                        navigateToModTools(context),
                                    style: ElevatedButton.styleFrom(),
                                    child: const Text("Mod Tools"))
                                : OutlinedButton(
                                    onPressed: () =>
                                        joinCommunity(ref, community, context),
                                    style: ElevatedButton.styleFrom(),
                                    child: Text(
                                        community.members.contains(userId)
                                            ? "Leave"
                                            : "Join")),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                              "${community.members.length.toString()} members"),
                        )
                      ]),
                    ),
                  ),
                ];
              },
              body: ref.watch(getCommunityPostProvider(community.name)).when(
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
