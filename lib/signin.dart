import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maglev_vault/main.dart';
import 'package:maglev_vault/privacypolicy.dart';
import 'package:maglev_vault/termsofservice.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final String _errorMessage = '';
  Box signin = Hive.box('signin');

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }

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

  Future<UserCredential> signInWithApple() async {
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
    return FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Widget logo() {
    return Image(
      height: Get.width * 0.15,
      image: const AssetImage('assets/images/launchscreen.png'),
    );
  }

  Widget errorMessage() {
    return Text(_errorMessage);
  }

  Widget appleButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.03, vertical: Get.height * 0.01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 20,
          primary: CupertinoColors.systemBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Get.width * 0.07),
          ),
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.apple,
              color: CupertinoColors.black,
              size: Get.width * 0.05,
            ),
            SizedBox(
              width: Get.width * 0.05,
            ),
            Text(
              'Continue with Apple',
              style: TextStyle(
                color: CupertinoColors.black,
                fontSize: Get.width * 0.04,
              ),
            ),
          ],
        ),
        onPressed: () async {
          try {
            await signInWithApple();
            signin.put('signed_in', true);

            Get.offAll(
              () => const Main(),
            );
          } catch (e) {
            Get.snackbar('Oops!', 'Something went wrong. Please try again!');
          }
        },
      ),
    );
  }

  Widget anonymousButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.03, vertical: Get.height * 0.01),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 20,
          primary: CupertinoColors.systemBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Get.width * 0.07),
          ),
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.lock,
              color: CupertinoColors.black,
              size: Get.width * 0.04,
            ),
            SizedBox(
              width: Get.width * 0.05,
            ),
            Text(
              'Stay Anonymous',
              style: TextStyle(
                color: CupertinoColors.black,
                fontSize: Get.width * 0.04,
              ),
            ),
          ],
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signInAnonymously();
            signin.put('signed_in', true);

            Get.offAll(
              () => const Main(),
            );
          } catch (e) {
            Get.snackbar('Oops!', 'Something went wrong. Please try again!');
          }
        },
      ),
    );
  }

  Widget policies() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
      child: Text.rich(
        TextSpan(
          text: 'By signing up, you agree to our ',
          style: TextStyle(
            fontSize: Get.width * 0.03,
            color: CupertinoColors.black,
          ),
          children: <TextSpan>[
            TextSpan(
                text: 'Terms of Service',
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(() => const TermsOfService());
                  }),
            const TextSpan(
              text: ' and ',
            ),
            TextSpan(
              text: 'Privacy Policy.',
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(() => const PrivacyPolicy());
                },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 8,
              ),
              logo(),
              const Spacer(
                flex: 2,
              ),
              Text(
                greeting(),
                style: TextStyle(
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: Get.width * 0.075,
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Text(
                'No tracking. No ads. Ever.',
                style: TextStyle(
                  fontSize: Get.width * 0.04,
                  color: CupertinoColors.black,
                  fontFamily: 'Dongle',
                ),
              ),
              const Spacer(
                flex: 10,
              ),
              appleButton(),
              anonymousButton(),
              const Spacer(),
              policies(),
              const Spacer(
                flex: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
