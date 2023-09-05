import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/theme/pallete.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  void dispose() {
    communityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a community"),
      ),
      body: isLoading
          ? const LoaderWidget()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Community name"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: communityNameController,
                    decoration: const InputDecoration(
                      hintText: 'r/Community_name',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    maxLength: 21,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () => createCommunity(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.blueColor,
                        minimumSize: const Size(double.infinity, 50)),
                    child: const Text(
                      "Create community",
                      style: TextStyle(
                        color: Pallete.whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
