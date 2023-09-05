import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});
  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: Text('Create a community'),
            leading: Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          ),
          ref.watch(userCommunitiesProvider).when(
              data: (communities) => Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (context, index) {
                        final community = communities[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name.toString()}'),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
              error: (error, stackTrace) =>
                  ErrorText(errorText: error.toString()),
              loading: () => const LoaderWidget())
        ],
      )),
    );
  }
}
