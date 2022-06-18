import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:maglev_vault/main.dart';
import 'package:maglev_vault/photo.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class PhotoPasscode extends StatefulWidget {
  const PhotoPasscode({Key? key}) : super(key: key);

  @override
  State<PhotoPasscode> createState() => _PhotoPasscodeState();
}

class _PhotoPasscodeState extends State<PhotoPasscode> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = false;

    if (passcodeboxReady &&
        passcodebox!.get("photoPasscode") != null &&
        enteredPasscode == passcodebox!.get("photoPasscode")) {
      isValid = true;
    }
    _verificationNotifier.add(isValid);
  }

  Box? passcodebox;
  Future<bool> setupEncryptedBox() async {
    const secureStorage = FlutterSecureStorage();
    // if key not exists return null
    final encryprionKey = await secureStorage.read(key: 'passcodeKey');
    if (encryprionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'passcodeKey',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'passcodeKey');
    final encryptionKey = base64Url.decode(key!);
    passcodebox = await Hive.openBox('passcodeBox',
        encryptionCipher: HiveAesCipher(encryptionKey));
    return true;
  }

  bool passcodeboxReady = false;

  @override
  void initState() {
    setupEncryptedBox().then((value) {
      setState(() {
        passcodeboxReady = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: PasscodeScreen(
          title: Text(
            "Enter Passcode",
            style: TextStyle(
              color: Colors.white,
              fontSize: Get.width * 0.05,
              fontWeight: FontWeight.w300,
            ),
          ),
          passwordEnteredCallback: (String enteredPasscode) {
            _onPasscodeEntered(enteredPasscode);
          },
          cancelButton: const Text(''),
          deleteButton: const Text(
            'Delete',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          shouldTriggerVerification: _verificationNotifier.stream,
          isValidCallback: () {
            Get.to(() => const Main());
            Get.to(() => const Photo());
          },
        ));
  }
}
