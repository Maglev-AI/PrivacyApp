import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:maglev_vault/photo.dart';
import 'package:photo_view/photo_view.dart';

class PhotoDetail extends StatefulWidget {
  final String imgPath;
  final int imgIndex;

  const PhotoDetail({
    Key? key,
    required this.imgPath,
    required this.imgIndex,
  }) : super(key: key);

  @override
  State<PhotoDetail> createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  String zoomState = 'initial';
  bool showAppbar = false;
  bool encryptedBoxReady = false;
  Box? encryptedBox;

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

  @override
  void initState() {
    setupEncryptedBox().then((value) {
      setState(() {
        encryptedBoxReady = value;
      });
    });
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return !encryptedBoxReady
        ? CupertinoActivityIndicator()
        : encryptedBox!.isEmpty
            ? Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.back),
                    onPressed: () {
                      Get.to(() => const Photo());
                    },
                  ),
                ),
                body: const Center(
                  child: Text(
                    "M Photo Vault is empty.",
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                ),
              )
            : Hero(
                tag: widget.imgIndex,
                child: GestureDetector(
                    onTap: () {
                      setState(() =>
                          showAppbar = !showAppbar); // you missed setState
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CarouselSlider.builder(
                            itemCount: encryptedBox!.keys.length,
                            options: CarouselOptions(
                              height: Get.height,
                              scrollPhysics: zoomState == 'initial'
                                  ? const ClampingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              viewportFraction: 1,
                              initialPage: widget.imgIndex,
                              enableInfiniteScroll: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) {
                              currentIndex = itemIndex;
                              return PhotoView(
                                  imageProvider: Image.file(
                                    File(widget.imgPath +
                                        '/' +
                                        encryptedBox!.keys.toList()[itemIndex]),
                                  ).image,
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale:
                                      PhotoViewComputedScale.contained * 5,
                                  scaleStateChangedCallback: (value) {
                                    setState(() {
                                      zoomState = value.name;
                                    });
                                  });
                            }),
                        if (showAppbar)
                          SizedBox(
                            height: Get.height * 0.15,
                            child: AppBar(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              leading: IconButton(
                                icon: const Icon(CupertinoIcons.back),
                                onPressed: () {
                                  Get.to(() => const Photo());
                                },
                              ),
                              actions: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Are you sure?'.tr),
                                          content: Text(
                                              'This photo will be permanently deleted and wiped from the phone.'
                                                  .tr),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: Text(
                                                'Yes, I\'m sure'.tr,
                                                style: const TextStyle(
                                                  color: CupertinoColors
                                                      .destructiveRed,
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  encryptedBox!
                                                      .deleteAt(currentIndex);
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
                                ),
                              ],
                            ),
                          ),
                      ],
                    )),
              );
  }
}
