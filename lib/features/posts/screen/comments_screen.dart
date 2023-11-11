import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/features/posts/widget/comment_card.dart';

import '../../../models/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postID;
  const CommentScreen({super.key, required this.postID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  TextEditingController commentControler = TextEditingController();

  @override
  void dispose() {
    commentControler.dispose();
    super.dispose();
  }

  void addComment(WidgetRef ref, Post post) {
    ref.watch(postControllerProvider.notifier).addComment(
        context: context,
        text: commentControler.text.trim().toString(),
        post: post);
    setState(() {
      commentControler.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIDProvider(widget.postID)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (value) => addComment(ref, data),
                    controller: commentControler,
                    decoration: const InputDecoration(
                      hintText: "what are your thoughts",
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  ref.watch(getPostCommentsProvider(widget.postID)).when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                final comment = data.elementAt(index);
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorWidget(error);
                        },
                        loading: () => const LoaderWidget(),
                      )
                ],
              );
            },
            error: (error, stackTrace) => ErrorWidget(error),
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
