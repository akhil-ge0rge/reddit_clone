import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push("/mod-tools/$name");
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
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(),
                                      child: Text(
                                          community.members.contains(userId)
                                              ? "Joined"
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
                body: Text("Post")),
            error: (error, stackTrace) =>
                ErrorText(errorText: error.toString()),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
