import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:maglev_vault/signin.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Widget deleteAccount() {
    return ListTile(
      title: const Text(
        'Delete Account',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: IconButton(
        color: Colors.red,
        onPressed: () {
          Get.bottomSheet(
            const BottomSheetWidget(),
          );
        },
        icon: const Icon(Icons.delete),
      ),
      onTap: () {
        Get.bottomSheet(
          const BottomSheetWidget(),
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
          subject: 'M Vault - Hide Photo & Password Through Encryption',
        );
        Navigator.pop(context);
      },
    );
  }

  Widget version() {
    return ListTile(
      title: const Text('Crafted @ MIT'),
      subtitle: const Text('Version 1.13.0'),
      leading: IconButton(
        color: Colors.redAccent,
        onPressed: () async {},
        icon: const Icon(Icons.favorite),
      ),
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
          divider(),
          deleteAccount(),
          divider(),
          version(),
        ],
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final user = FirebaseAuth.instance.currentUser;
  GetStorage vault = GetStorage('vault');
  Box signin = Hive.box('signin');

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<OAuthCredential> appleAuth() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return oauthCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      margin: EdgeInsets.symmetric(
        vertical: 25.w,
        horizontal: 15.w,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.all(Radius.circular(25.w)),
        boxShadow: [
          BoxShadow(
            color: Colors.red,
            blurRadius: 10.w,
            spreadRadius: 5.w,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            blurRadius: 10.w,
            spreadRadius: 0.w,
          ), //BoxShadow
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.w),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Delete this account?',
                style: TextStyle(
                    fontSize: 20.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 60.w,
            ),
            Text(
              'You will lose access to Maglev Autopilot and all of your Maglev Coins. \n \n \n \n Are you sure you want to proceed?',
              style: TextStyle(
                fontSize: 15.w,
                color: Colors.black,
                height: 1.1,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 75.w,
            ),
            ActionChip(
              backgroundColor: const Color.fromARGB(255, 255, 218, 230),
              labelPadding: EdgeInsets.symmetric(
                horizontal: 75.w,
                vertical: 10.w,
              ),
              label: Text(
                'Delete',
                style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 20.w,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                if (user != null) {
                  if (!user!.isAnonymous) {
                    AuthCredential appleAuthCredential = await appleAuth();

                    await user
                        ?.reauthenticateWithCredential(appleAuthCredential);
                  }

                  Get.offAll(
                    () => const SignIn(),
                  );

                  await user?.delete();

                  vault.erase();
                  await signin.deleteFromDisk();

                  await Hive.initFlutter();
                  await Hive.openBox('signin');

                  Get.snackbar(
                    'We\'re sorry to see you go',
                    'Your account has been deleted.',
                    duration: const Duration(seconds: 3),
                    colorText: Colors.white,
                    backgroundColor: CupertinoColors.destructiveRed,
                  );
                } else {
                  Get.snackbar(
                    'User not found',
                    'It appears that your account has already been deleted.',
                    duration: const Duration(seconds: 10),
                    colorText: Colors.white,
                    backgroundColor: CupertinoColors.destructiveRed,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
