import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'drawer.dart';

class Diagnostics extends StatefulWidget {
  const Diagnostics({Key? key}) : super(key: key);

  @override
  State<Diagnostics> createState() => _DiagnosticsState();
}

class _DiagnosticsState extends State<Diagnostics> {
  late TextEditingController _editingController;
  String _pwdInput = '';
  int pwdScore = 0;
  String timeToCrack = '< 1 second'.tr;

  int evaluatePassword(String pwd) {
    int length = pwd.length;
    int isNumberOnly = pwd.isNumericOnly ? 1 : 0;
    int isAlphabetOnly = pwd.isAlphabetOnly ? 1 : 0;
    int containsSpecialChar = pwd.contains(RegExp('[^A-Za-z0-9]')) ? 1 : 0;
    int score = length * 5 -
        isNumberOnly * 20 -
        isAlphabetOnly * 5 -
        containsSpecialChar * 5;

    if (score > 100) {
      score = 100;
    }
    if (score < 0) {
      score = 0;
    }
    return score;
  }

  String crackTime(String pwd) {
    int length = pwd.length;
    int isNumberOnly = pwd.isNumericOnly ? 1 : 0;
    int isAlphabetOnly = pwd.isAlphabetOnly ? 1 : 0;
    if (isNumberOnly == 0) {
      if (length <= 10) {
        return '< 1 second'.tr;
      } else {
        if (length > 18) {
          return '> 1 year'.tr;
        } else {
          switch (length) {
            case 11:
              return '2 seconds'.tr;
            case 12:
              return '25 seconds'.tr;
            case 13:
              return '4 minutes'.tr;
            case 14:
              return '41 minutes'.tr;
            case 15:
              return '6 hours'.tr;
            case 16:
              return '2 days'.tr;
            case 17:
              return '4 weeks'.tr;
            case 18:
              return '9 months'.tr;
          }
        }
      }
    } else {
      if (isAlphabetOnly == 0) {
        if (length <= 7) {
          return '< 1 second'.tr;
        } else {
          if (length > 18) {
            return '> 1 year'.tr;
          } else {
            switch (length) {
              case 8:
                return '5 seconds'.tr;
              case 9:
                return '2 minutes'.tr;
              case 10:
                return '58 minutes'.tr;
              case 11:
                return '1 day'.tr;
              case 12:
                return '3 weeks'.tr;
              case 13:
                return '1 year'.tr;
            }
          }
        }
      } else {
        if (length <= 5) {
          return '< 1 second'.tr;
        } else {
          if (length > 9) {
            return '> 1 year'.tr;
          } else {
            switch (length) {
              case 6:
                return '5 seconds'.tr;
              case 7:
                return '6 minutes'.tr;
              case 8:
                return '8 hours'.tr;
              case 9:
                return '3 weeks'.tr;
              case 10:
                return '11 months'.tr;
            }
          }
        }
      }
    }
    return '< 1 second'.tr;
  }

  @override
  Widget build(BuildContext context) {
    _editingController = TextEditingController(text: _pwdInput);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: CupertinoColors.black,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: CupertinoColors.white,
            title: Text(
              'Password Diagnostics'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          drawer: const SideDrawer(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(
                  flex: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Get.width * 0.03),
                    ),
                  ),
                  child: ListTile(
                    title: TextField(
                      onSubmitted: (input) {
                        setState(() {
                          _pwdInput = input;
                          pwdScore = evaluatePassword(input);
                          timeToCrack = crackTime(input);
                        });
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
                const Spacer(
                  flex: 1,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Get.width * 0.03),
                      topRight: Radius.circular(Get.width * 0.03),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "Password Length: ".tr,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    trailing: Text(
                      _pwdInput.length.toString(),
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                /*Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey5.withOpacity(0.2),
              ),
              child: ListTile(
                title: const Text(
                  "Password Security Score: ",
                  style: TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                trailing: Text(
                  pwd_score.toString() + ' / 100',
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),*/
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Get.width * 0.03),
                      bottomRight: Radius.circular(Get.width * 0.03),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      "Time To Crack: ".tr,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    trailing: Text(
                      timeToCrack,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
