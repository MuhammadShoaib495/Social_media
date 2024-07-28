import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/screen/add_post_Screen.dart';
import 'package:social_media/screen/feed_screen.dart';
import 'package:social_media/screen/profile_screen.dart';
import 'package:social_media/screen/search_screen.dart';

const webScreenSize = 600;

List<Widget>homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('fourth'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];