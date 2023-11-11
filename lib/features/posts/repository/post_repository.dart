import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/type_def.dart';
import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postRepositoryProvider =
    Provider((ref) => PostRepository(firestore: ref.watch(firebaseProviders)));

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUsersPost(List<Community> communities) {
    return _post
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Post.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(
        _post.doc(post.id).delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  void upVote(Post post, String userID) async {
    if (post.downvotes.contains(userID)) {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userID]),
      });
    }
    if (post.upvotes.contains(userID)) {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userID]),
      });
    } else {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userID]),
      });
    }
  }

  void downVote(Post post, String userID) {
    if (post.upvotes.contains(userID)) {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userID]),
      });
    }
    if (post.downvotes.contains(userID)) {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userID])
      });
    } else {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userID])
      });
    }
  }

  Stream<Post> getPostByID(String postID) {
    return _post
        .doc(postID)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(_post
          .doc(comment.postId)
          .update({'commentCount': FieldValue.increment(1)}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> fetchPostComments(String postID) {
    return _comments
        .where(
          'postId',
          isEqualTo: postID,
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map(
              (e) => Comment.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList());
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      await _post.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award])
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award])
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
