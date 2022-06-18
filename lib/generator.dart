import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maglev_vault/pwd_view.dart';

class Generator extends StatefulWidget {
  const Generator({Key? key}) : super(key: key);

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  String pwd = '';
  int pwdLength = 20;
  late TextEditingController _editingController;
  String _pwdInput = '';

  @override
  Widget build(BuildContext context) {
    _editingController = TextEditingController(text: _pwdInput);

    return Scaffold(
      backgroundColor: CupertinoColors.black,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: CupertinoColors.white,
        title: Text(
          'New Password'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            if (pwd.isEmpty)
              Row(
                children: [
                  const Spacer(),
                  Text(
                    pwd.isNotEmpty ? ''.tr : 'Backup Existing Password'.tr,
                    style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: Get.width * 0.04,
                        fontWeight: FontWeight.w300),
                  ),
                  const Spacer(
                    flex: 15,
                  ),
                ],
              ),
            if (pwd.isEmpty) const Spacer(),
            if (pwd.isEmpty)
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Get.width * 0.03),
                  ),
                ),
                child: ListTile(
                  title: TextField(
                    onChanged: (input) {
                      _pwdInput = input;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    cursorColor: CupertinoColors.systemOrange,
                    style: const TextStyle(color: Colors.white),
                    controller: _editingController,
                    decoration: InputDecoration(
                      labelText: 'Enter password...'.tr,
                      labelStyle: TextStyle(
                        color: CupertinoColors.systemGrey.withOpacity(0.7),
                      ),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: _editingController.clear,
                        icon: const Icon(Icons.cancel),
                        color: CupertinoColors.systemGrey.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            if (pwd.isEmpty)
              const Spacer(
                flex: 7,
              ),
            if (pwd.isEmpty)
              Center(
                child: CupertinoButton(
                  color: CupertinoColors.systemBlue,
                  child: Text(
                    'Save'.tr,
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * 0.05,
                    ),
                  ),
                  onPressed: () {
                    setState(
                      () {
                        pwd = _pwdInput;
                      },
                    );
                  },
                ),
              ),
            const Spacer(
              flex: 3,
            ),
            if (pwd.isEmpty)
              Row(
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: Divider(
                          color: CupertinoColors.systemGrey,
                          height: Get.width * 0.1,
                        )),
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: Divider(
                          color: CupertinoColors.systemGrey,
                          height: Get.width * 0.1,
                        )),
                  ),
                ],
              ),
            if (pwd.isEmpty)
              const Spacer(
                flex: 3,
              ),
            Row(
              children: [
                const Spacer(),
                Text(
                  pwd.isNotEmpty
                      ? 'Password'.tr
                      : 'Generate Financial-grade Password'.tr,
                  style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: Get.width * 0.04,
                      fontWeight: FontWeight.w300),
                ),
                const Spacer(
                  flex: 20,
                ),
              ],
            ),
            const Spacer(),
            if (pwd.isEmpty)
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Get.width * 0.03),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Center(
                          child: Text(
                            'Length: $pwdLength',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * 0.05,
                            ),
                          ),
                        ),
                        subtitle: Center(
                          child: Text(
                            pwdLength < 8
                                ? 'Weak'.tr
                                : pwdLength < 20
                                    ? 'Acceptable'.tr
                                    : pwdLength < 28
                                        ? 'Secure'.tr
                                        : 'Bulletproof'.tr,
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Get.width * 0.025,
                            ),
                          ),
                        ),
                      ),
                      Slider(
                        min: 6,
                        max: 34,
                        value: pwdLength.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            pwdLength = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            if (pwd.isNotEmpty)
              ListTile(
                title: Text(
                  pwd,
                  maxLines: 3,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontSize: Get.width * 0.05,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: pwd));
                    Get.snackbar(
                      'Password copied to clipboard'.tr,
                      'Your password is now available.'.tr,
                      colorText: CupertinoColors.white,
                      backgroundColor: CupertinoColors.activeBlue,
                      duration: const Duration(milliseconds: 1500),
                      animationDuration: const Duration(milliseconds: 500),
                    );
                  },
                  icon: Icon(Icons.copy,
                      color: Colors.white, size: Get.width * 0.08),
                ),
              ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.03,
              ),
              child: Text(
                'Recommended Length: 20 characters and above'.tr,
                maxLines: 5,
                style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: Get.width * 0.03,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(
              flex: 7,
            ),
            Center(
              child: CupertinoButton(
                color: pwd == ''
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.activeGreen,
                child: Text(
                  pwd == '' ? 'Generate'.tr : 'Save'.tr,
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.05,
                  ),
                ),
                onPressed: () {
                  if (pwd.isEmpty) {
                    setState(
                      () {
                        pwd = createCryptoRandomString(pwdLength);
                      },
                    );
                  } else {
                    Get.off(() => PasswordView(
                          tag: '',
                          pwd: pwd,
                        ));
                  }
                },
              ),
            ),
            const Spacer(
              flex: 7,
            ),
          ],
        ),
      ),
    );
  }

  static String createCryptoRandomString([int length = 20]) {
    final Random random = Random.secure();

    var values = List<int>.generate(length, (i) => random.nextInt(256));

    return base64Url.encode(values).substring(0, length);
  }
}
