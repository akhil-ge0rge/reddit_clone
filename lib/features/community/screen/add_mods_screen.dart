import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModeratorsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModeratorsScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddModeratorsScreenState();
}

class _AddModeratorsScreenState extends ConsumerState<AddModeratorsScreen> {
  Set<String> uids = {};

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addModsCommunity(
          context,
          widget.name,
          uids.toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final member = community.members.elementAt(index);
                return ref.watch(getUserDataProvider(member)).when(
                      data: (user) {
                        if (community.mods.contains(member)) {
                          uids.add(member);
                        }
                        return CheckboxListTile(
                          value: uids.contains(member),
                          onChanged: (bool? value) {
                            if (value!) {
                              addUid(member);
                            } else {
                              removeUid(member);
                            }
                          },
                          title: Text(
                            user.name,
                          ),
                        );
                      },
                      error: (error, stackTrace) => ErrorWidget(error),
                      loading: () => const LoaderWidget(),
                    );
              },
            ),
            error: (error, stackTrace) => ErrorWidget(error),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
