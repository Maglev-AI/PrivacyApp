import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:maglev_vault/main.dart';
import 'package:maglev_vault/photo.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class SetPasscode extends StatefulWidget {
  const SetPasscode({Key? key}) : super(key: key);

  @override
  State<SetPasscode> createState() => _SetPasscodeState();
}

class _SetPasscodeState extends State<SetPasscode> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = enteredPasscode.length == 6;
    passcodebox!.put("photoPasscode", enteredPasscode);
    _verificationNotifier.add(isValid);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: PasscodeScreen(
        title: Text(
          "Set Your Passcode",
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
      ),
    );
  }
}
