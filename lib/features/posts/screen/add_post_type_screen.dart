import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/controller/post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import '../../../core/providers/utils.dart';
import '../../../theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  File? bannerFile;
  final titleEditingController = TextEditingController();
  final descEditingController = TextEditingController();
  final linkEditingController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;
  Uint8List? bannerWebFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerFile != null || bannerWebFile != null) &&
        titleEditingController.text != '') {
      ref.read(postControllerProvider.notifier).sharedImagePost(
          context: context,
          title: titleEditingController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile,
          webFile: bannerWebFile);
    } else if (widget.type == 'text' && titleEditingController.text != '') {
      ref.read(postControllerProvider.notifier).sharedTextPost(
            context: context,
            title: titleEditingController.text.trim(),
            description: descEditingController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );
    } else if (widget.type == 'link' &&
        titleEditingController.text != '' &&
        linkEditingController.text != '') {
      ref.read(postControllerProvider.notifier).sharedLinkPost(
            context: context,
            title: titleEditingController.text.trim(),
            link: linkEditingController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );
    } else {
      showSnackBar(context, 'Please enter all fields');
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
    descEditingController.dispose();
    linkEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const LoaderWidget()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleEditingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter title here',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 30,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (isTypeImage)
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Pallete
                              .darkModeAppTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerWebFile != null
                                ? Image.memory(bannerWebFile!)
                                : bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : const Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Enter description here',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLines: 5,
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkEditingController,
                        decoration: const InputDecoration(
                          hintText: 'Enter link here',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: const Text('Select Community')),
                    ref.watch(userCommunitiesProvider).when(
                        data: (data) {
                          communities = data;
                          if (data.isEmpty) {
                            return SizedBox();
                          }

                          return DropdownButton(
                            value: selectedCommunity ?? data[0],
                            items: data
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCommunity = value;
                              });
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorWidget(error.toString()),
                        loading: () => LoaderWidget()),
                  ],
                ),
              ),
            ),
    );
  }
}
