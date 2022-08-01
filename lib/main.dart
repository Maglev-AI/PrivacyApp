import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maglev_vault/diagnostics.dart';
import 'package:maglev_vault/photo_passcode.dart';
import 'package:maglev_vault/set_passcode.dart';
import 'package:maglev_vault/signin.dart';
import 'package:maglev_vault/translation.dart';
import 'package:maglev_vault/vault.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await GetStorage.init();
  await Hive.initFlutter();
  await Hive.openBox('signin');
  Box signin = Hive.box('signin');
  Future _updateSignIn() async {
    if (signin.get('signed_in') == null) {
      signin.put('signed_in', false);
    }
  }

  _updateSignIn();

  runApp(const MaglevVault());
}

class MaglevVault extends StatelessWidget {
  const MaglevVault({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Box signin = Hive.box('signin');

    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Maglev Vault',
            translations: Translation(),
            locale: Get.deviceLocale,
            debugShowCheckedModeBanner: false,
            home: signin.get('signed_in') ? const Main() : const SignIn(),
          );
        });
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Box? passcodebox;

  Future<bool> setupSecureBox() async {
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

    if (passcodebox!.get("photoPasscode") != null) {
      return true;
    } else {
      return false;
    }
  }

  bool hasPasscode = false;

  @override
  void initState() {
    setupSecureBox().then((value) {
      setState(() {
        hasPasscode = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List pageOptions = [
      const Vault(),
      const Diagnostics(),
      if (hasPasscode) const PhotoPasscode(),
      if (!hasPasscode) const SetPasscode()
    ];

    return Scaffold(
      body: pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CupertinoColors.black.withOpacity(1),
        elevation: 0,
        unselectedItemColor: CupertinoColors.systemGrey,
        selectedItemColor: CupertinoColors.systemOrange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.lock),
            label: 'Vault'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.engineering_outlined),
            label: 'Diagnostics'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo),
            label: 'Photos'.tr,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
