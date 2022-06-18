import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maglev_vault/main.dart';

class PasswordView extends StatefulWidget {
  final String tag;

  final String pwd;

  const PasswordView({Key? key, required this.tag, required this.pwd})
      : super(key: key);

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  late TextEditingController _editingController;
  String initialText = '';
  late String newTag;
  String errorMessage = '';

  GetStorage vault = GetStorage('vault');
  GetStorage color = GetStorage('color');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initialText = widget.tag;
    newTag = widget.tag;
    _editingController = TextEditingController(text: initialText);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: CupertinoColors.black,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: CupertinoColors.white,
          title: Text('Saved Password'.tr),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: Text('Are you sure?'.tr),
                      content: Text(
                          'Once this password is permanently wiped from the vault, it can\'t be recovered.'
                              .tr),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text(
                            'Yes, I\'m sure'.tr,
                            style: const TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                          onPressed: () {
                            vault.remove(newTag);
                            Navigator.pop(context);
                            Get.off(() => const Main());
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(
                            'No'.tr,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Delete'.tr,
                style: const TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 2,
              ),
              Text(
                errorMessage,
                maxLines: 3,
                style: TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: Get.width * 0.03,
                    fontWeight: FontWeight.w300),
              ),
              const Spacer(
                flex: 5,
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Tag'.tr,
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
                      newTag = input;
                      errorMessage = '';
                    },
                    cursorColor: CupertinoColors.systemOrange,
                    style: const TextStyle(color: Colors.white),
                    controller: _editingController,
                    decoration: InputDecoration(
                      labelText: 'What is the password for?'.tr,
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
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                ),
                child: Text(
                  'This tag is encrypted and stored on your phone locally. It is only available to you. You can change it any time.'
                      .tr,
                  maxLines: 5,
                  style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: Get.width * 0.03,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Password'.tr,
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
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Get.width * 0.03),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    widget.pwd,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.pwd));
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
                        color: Colors.white, size: Get.width * 0.05),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                ),
                child: Text(
                  'To protect your privacy, this password is encrypted locally and cannot be changed. If you wish to change it in the future, use Maglev Vault to generate a new secure password.'
                      .tr,
                  maxLines: 5,
                  style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: Get.width * 0.03,
                      fontWeight: FontWeight.w300),
                ),
              ),
              const Spacer(
                flex: 20,
              ),
              Center(
                child: CupertinoButton(
                  color: CupertinoColors.activeGreen,
                  child: Text(
                    'Save'.tr,
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width * 0.05,
                    ),
                  ),
                  onPressed: () {
                    if (newTag.isEmpty) {
                      setState(() {
                        errorMessage =
                            'Please provide a tag. Give your password a name.'
                                .tr;
                      });
                    } else {
                      if (vault.read(newTag) != null) {
                        setState(() {
                          errorMessage =
                              'This password already exists. Pick a new tag.'
                                  .tr;
                        });
                      } else {
                        vault.remove(widget.tag);
                        vault.write(newTag, widget.pwd);
                        color.write(newTag,
                            color.read(widget.tag) ?? Random().nextInt(8));
                        color.remove(widget.tag);
                        Get.off(() => const Main());
                      }
                    }
                  },
                ),
              ),
              const Spacer(
                flex: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
