import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/models/user.dart' as model;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/resources/storage_methods.dart';

class  AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // user stat function updating inHome Screen

 Future<model.User> getUserDetails() async{
   User currentUser = _auth.currentUser!;

   DocumentSnapshot snap = await _firestore.collection('user').doc(currentUser.uid).get();
   return model.User.fromSnap(snap);
 }


  // Signup User Register
 Future<String> signUpUser({
   required String email,
   required String username,
   required String password,
   required String bio,
   required Uint8List file,
 }) async {

   String res = 'Some error Occurred';

   try{
     if(email.isNotEmpty && username.isNotEmpty && password.isNotEmpty && bio.isNotEmpty && file != null){
       // register user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(cred.user!.uid);
     // registered completed
      //-----------------------------------------------------------------------------------
      //photoUrl parameters UploadimageToStorage String childName, Uint8List file, bool isPost,//

      String photoUrl = await StorageMethods().uploadImageToStorage('profile', file, false);
      // Create Model for big app bug
      model.User user = model.User(
        username: username,
        email: email,
        uid: cred.user!.uid,
        photoUrl: photoUrl,
        bio: bio,
        following: [],
        followers: [],
      );
      // add user in our database details like username, bio, file through Map Json;
       await _firestore.collection('user').doc(cred.user!.uid).set(user.toJson());

       res = "Success";

     } else {
       res = "Please fill all boxes";
     }
   } catch(err) {
     res = err.toString();
   }
   return res;
 }
 Future<String> loginUser({
    required String email,
    required String password,
})async {
   String res = "Some error Occurred";
   try {
     if (email.isNotEmpty || password.isNotEmpty) {
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = "Success";
     } else {
       res = "Please enter all the fields";
     }
   } catch (err) {
     res = err.toString();
   }
   return res;
 }

 Future<void> signOut() async{
   await _auth.signOut();
 }
}