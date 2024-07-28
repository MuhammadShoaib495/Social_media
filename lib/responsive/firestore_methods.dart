 import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/post.dart';
import 'package:social_media/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profImage,
      ) async {
    String res = "Some Error Occurred";
    try {
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post (
          description: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          postUrl: photoUrl,
          datePublished: DateTime.now(),
          profImage: profImage
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch(err)  {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async{
    String res = "Some error occurred";
    try {
      if(likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });

      } else {
        // else we need to add uid to the likes array
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        }
        );
      }

    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> postComment (String postId, String text, String uid, String name, String profilePic) async {

    try {
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
            {
              'profilePic': profilePic,
              'name': name,
              'uid': uid,
              'text': text,
              'commentId': commentId,
              'datePublished': DateTime.now(),
            });
      } else {
        print('Text is empty');
    }
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try{
      await _firestore.collection('posts').doc(postId).delete();
    } catch(err){
      print(err.toString());
    }
  }

  Future<void> followUser(
      String uid,//own Uid
      String followId,// who follows us
      ) async {
      try {
        DocumentSnapshot snap = await _firestore.collection('user').doc(uid).get();
        List following = (snap.data()! as dynamic)['following'];

        if(following.contains(followId)){
          await _firestore.collection('user').doc(followId).update({
            'followers': FieldValue.arrayRemove([uid])// remove other usr followers
          });
          await _firestore.collection('user').doc(uid).update({
            'following': FieldValue.arrayRemove([followId])//current user remove following
          });
        } else {
          await _firestore.collection('user').doc(followId).update({
            'followers': FieldValue.arrayUnion([uid])
          });
          await _firestore.collection('user').doc(uid).update({
            'following': FieldValue.arrayUnion([followId])
          });
        }
      } catch (e) {
        print(e.toString());
      }
  }


 }