import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:maglev_vault/drawer.dart';
import 'package:maglev_vault/generator.dart';
import 'package:maglev_vault/pwd_view.dart';

class Vault extends StatefulWidget {
  const Vault({Key? key}) : super(key: key);

  @override
  State<Vault> createState() => _VaultState();
}

class _VaultState extends State<Vault> {
  GetStorage vault = GetStorage('vault');
  GetStorage color = GetStorage('color');

  late bool hasPWD;
  List<Map> pwdList = [];

  List colors = [
    CupertinoColors.activeBlue,
    CupertinoColors.activeOrange,
    CupertinoColors.systemPink,
    CupertinoColors.activeGreen,
    CupertinoColors.systemYellow,
    CupertinoColors.systemPurple,
    CupertinoColors.systemIndigo,
    CupertinoColors.systemTeal,
  ];

  List<Map> getPasswordList() {
    List<Map> pwdList = [];
    for (String tag in vault.getKeys()) {
      pwdList.add({
        'tag': tag,
        'pwd': vault.read(tag),
      });
    }
    return pwdList;
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshData,
        child: GestureDetector(
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
                  'Vault'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Get.width * 0.08),
                ),
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
                                'Once passwords are all permanently wiped from the vault, they can\'t be recovered.'
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
                                  setState(() {
                                    vault.erase();
                                    pwdList = [];
                                  });
                                  Navigator.pop(context);
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
                      'Clear All'.tr,
                      style: const TextStyle(
                        color: CupertinoColors.destructiveRed,
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Get.to(() => const Generator());
                },
                tooltip: 'New Password'.tr,
                child: const Icon(Icons.add),
              ),
              drawer: const SideDrawer(),
              body: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.01, horizontal: Get.width * 0.05),
                child: ListView(
                  children: [
                    CupertinoSearchTextField(
                      placeholder: 'Search passwords'.tr,
                      style: const TextStyle(
                        color: CupertinoColors.white,
                      ),
                      backgroundColor:
                          CupertinoColors.systemGrey.withOpacity(0.3),
                      itemColor: CupertinoColors.systemGrey,
                      onChanged: (String value) {
                        List<Map> pwdListTemp = [];
                        for (String tag in vault.getKeys()) {
                          if (tag.toLowerCase().contains(value.toLowerCase())) {
                            pwdListTemp.add({
                              'tag': tag,
                              'pwd': vault.read(tag),
                            });
                          }
                        }
                        setState(() {
                          pwdList = pwdListTemp;
                        });
                      },
                    ),
                    SizedBox(
                      height: Get.width * 0.1,
                    ),
                    for (var pwdItem in pwdList.reversed)
                      Column(
                        children: [
                          passwordTile(
                            pwdItem['tag'],
                            pwdItem['pwd'],
                          ),
                          SizedBox(
                            height: Get.width * 0.05,
                          ),
                        ],
                      ),
                    DottedBorder(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                      color: CupertinoColors.systemGrey3,
                      strokeCap: StrokeCap.butt,
                      strokeWidth: 2,
                      dashPattern: const [8, 10],
                      child: InkWell(
                        onTap: () {
                          Get.to(() => const Generator());
                        },
                        child: SizedBox(
                          width: Get.width * 0.80,
                          height: Get.width * 0.2,
                          child: Center(
                            child: Text(
                              '+ New password'.tr,
                              style: TextStyle(
                                fontSize: Get.width * 0.04,
                                color: CupertinoColors.systemGrey2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget passwordTile(String tag, String pwd) {
    return InkWell(
      onTap: () {
        Get.to(() => PasswordView(tag: tag, pwd: pwd));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(64, 75, 96, .9),
          borderRadius: BorderRadius.all(
            Radius.circular(Get.width * 0.05),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.03, vertical: Get.width * 0.02),
          leading: Container(
            padding: EdgeInsets.only(right: Get.width * 0.03),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        width: Get.width * 0.003, color: Colors.white24))),
            child: Icon(
              Icons.circle,
              color: colors[color.read(tag) ?? 0],
            ),
          ),
          title: Text(
            tag,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: Get.width * 0.05),
          ),
          subtitle: Text(
            '*' * pwd.length,
            maxLines: 5,
            style: TextStyle(
              color: Colors.white,
              fontSize: Get.width * 0.03,
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
            icon: Icon(Icons.copy, color: Colors.white, size: Get.width * 0.08),
          ),
        ),
      ),
    );
  }

  Future _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      pwdList.clear();
      pwdList = getPasswordList();
    });
  }
}
