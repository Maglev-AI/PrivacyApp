import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maglev_vault/main.dart';
import 'package:maglev_vault/photoView.dart';
import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class Photo extends StatefulWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  List<XFile> imgFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool encryptedBoxReady = false;
  Box? encryptedBox;
  String myImagePath = '';

  Future<void> setupImageStorage() async {
    String appDir = '';
    await getApplicationDocumentsDirectory().then((value) {
      appDir = value.path;
    });
    myImagePath = '$appDir/Pics/';

// Create directory inside where file will be saved
    Directory(myImagePath).exists().then((exists) async {
      if (!exists) {
        await Directory(myImagePath).create();
      }
    });

// Path of file
  }

  Future<bool> setupEncryptedBox() async {
    const secureStorage = FlutterSecureStorage();
    // if key not exists return null
    final encryprionKey = await secureStorage.read(key: 'photoKey');
    if (encryprionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'photoKey',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'photoKey');
    final encryptionKey = base64Url.decode(key!);
    encryptedBox = await Hive.openBox('photoVault',
        encryptionCipher: HiveAesCipher(encryptionKey));
    return true;
  }

  Future setup() async {
    setupEncryptedBox().then((value) {
      setState(() {
        encryptedBoxReady = value;
      });
      setupImageStorage().then(
        (value) {
          setState(() {});
        },
      );
    });
  }

  void openGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      for (var image in images) {
        String baseName = basename(image.path);

        String savedLocation = "$myImagePath/$baseName";
// File copied to ext directory.
        await image.saveTo(savedLocation);

        setState(() {
          encryptedBox!.put(baseName, baseName);
        });
      }
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: CupertinoColors.black,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: CupertinoColors.white,
          leading: IconButton(
            onPressed: () {
              Get.to(() => const Main());
            },
            icon: const Icon(CupertinoIcons.back),
          ),
          title: Text(
            'Photos'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                openGallery();
              },
              child: const Text(
                "Add Photos",
              ),
            ),
          ],
          centerTitle: true,
        ),
        body: encryptedBoxReady
            ? encryptedBox!.isEmpty
                ? const Center(
                    child: Text(
                      "M Photo Vault is empty.",
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  )
                : GridView.count(
                    restorationId: 'grid_view_demo_grid_offset',
                    crossAxisCount: 3,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    padding: const EdgeInsets.all(3),
                    childAspectRatio: 0.8,
                    children: [
                      for (var i = 0; i < encryptedBox!.length; i++)
                        Hero(
                          tag: i,
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => PhotoDetail(
                                  imgPath: myImagePath,
                                  imgIndex: i,
                                ),
                              )!
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Image.file(
                              File("$myImagePath/" + encryptedBox!.keyAt(i)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  )
            : const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white60,
                ),
              ),
      ),
    );
  }
}
