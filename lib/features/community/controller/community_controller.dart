import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/providers/failure.dart';
import '../../../core/providers/utils.dart';
import '../../../models/post_model.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      ref: ref,
      communityRepository: communityRepository,
      storageRepository: storageRepository);
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});
final getCommunityPostProvider =
    StreamProvider.family((ref, String communityName) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityPost(communityName);
});

class CommunityController extends StateNotifier<bool> {
  final Ref _ref;
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;

  CommunityController(
      {required Ref ref,
      required CommunityRepository communityRepository,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)!.uid ?? "";
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created succesfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({
    required BuildContext context,
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? profileWebFile,
    required Uint8List? bannerWebFile,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null || profileWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/profile',
          id: community.name,
          file: profileFile,
          webFile: profileWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(avatar: r));
    }
    if (bannerFile != null || bannerWebFile != null) {
      final res = await _storageRepository.storeFile(
          path: 'communities/banner',
          id: community.name,
          file: bannerFile,
          webFile: bannerWebFile);
      res.fold((l) => showSnackBar(context, l.message),
          (r) => community = community.copyWith(banner: r));
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(BuildContext context, Community community) async {
    final userId = _ref.read(userProvider)!.uid;
    Either<Failure, void> res;
    if (community.members.contains(userId)) {
      res = await _communityRepository.leaveCommunity(community.name, userId);
    } else {
      res = await _communityRepository.joinCommunity(community.name, userId);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(userId)) {
        showSnackBar(context, "Community Left Successfully");
      } else {
        showSnackBar(context, "Community Join Successfully");
      }
    });
  }

  void addModsCommunity(
    BuildContext context,
    String communityName,
    List<String> uids,
  ) async {
    final res =
        await _communityRepository.addModsCommunity(communityName, uids);
    res.fold((l) => showSnackBar(context, l.message.toString()),
        (r) => Routemaster.of(context).pop());
  }

  Stream<List<Post>> getCommunityPost(String communityName) {
    return _communityRepository.getCommunityPosts(communityName);
  }
}
