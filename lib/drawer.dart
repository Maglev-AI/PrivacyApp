import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:maglev_vault/signin.dart';
import 'package:share_plus/share_plus.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  Box signin = Hive.box('signin');

  Widget divider() {
    return Divider(
      color: Colors.grey.shade400,
    );
  }

  Widget logout() {
    return ListTile(
      title: const Text('Log Out'),
      leading: IconButton(
          color: Colors.purple,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            signin.put('signed_in', false);

            Get.offAll(
              () => const SignIn(),
            );
          },
          icon: const Icon(Icons.logout)),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        signin.put('signed_in', false);

        Get.offAll(
          () => const SignIn(),
        );
      },
    );
  }

  Widget share() {
    return ListTile(
      title: const Text('Share'),
      leading: IconButton(
          color: Colors.purple,
          onPressed: () {},
          icon: const Icon(Icons.share)),
      onTap: () {
        Share.share(
          'https://apps.apple.com/us/app/id1592784615',
          subject: 'Maglev Vault - Encrypted Password Backup',
        );
        Navigator.pop(context);
      },
    );
  }

  Widget review() {
    return ListTile(
      title: const Text('Write A Review'),
      leading: IconButton(
        color: Colors.purple,
        onPressed: () async {
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
            Navigator.pop(context);

            inAppReview.openStoreListing(appStoreId: '1592784615');
          }
        },
        icon: const Icon(Icons.star),
      ),
      onTap: () async {
        final InAppReview inAppReview = InAppReview.instance;

        if (await inAppReview.isAvailable()) {
          Navigator.pop(context);

          inAppReview.openStoreListing(appStoreId: '1592784615');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        children: <Widget>[
          // ignore: avoid_unnecessary_containers
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
            child: Container(
              padding: EdgeInsets.only(top: Get.width * 0.01),
              // ignore: prefer_const_literals_to_create_immutables
              child: Column(
                children: [
                  Container(
                    height: Get.width * 0.15,
                    width: Get.width * 0.15,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/launchscreen.png')),
                    ),
                  ),
                  SizedBox(
                    height: Get.width * 0.02,
                  ),
                  Text(
                    'Anonymous',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * 0.05,
                    ),
                  ),
                ],
              ),
            ),
          ),
          logout(),
          divider(),
          share(),
          review(),
        ],
      ),
    );
  }
}
