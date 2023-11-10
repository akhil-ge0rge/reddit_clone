import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userCommunitiesProvider).when(
          data: (communities) =>
              ref.watch(userPostControllerProvider(communities)).when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final post = data.elementAt(index);
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      if (kDebugMode) {
                        print(error);
                      }
                      return ErrorWidget(error);
                    },
                    loading: () => const LoaderWidget(),
                  ),
          error: (error, stackTrace) => ErrorWidget(error),
          loading: () => const LoaderWidget(),
        );
  }
}
