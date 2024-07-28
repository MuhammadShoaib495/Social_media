
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/utils/global_variables.dart';

class Responsive extends StatefulWidget{
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const Responsive({super.key, required this.webScreenLayout, required this.mobileScreenLayout});

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false,);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
  return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth > webScreenSize) {
          return widget.webScreenLayout;
        }
        return widget.mobileScreenLayout;
      }
  );
  }
}