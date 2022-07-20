import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/models/color_schemes.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final roomcont = Get.find<ChatRoomController>();
  final TextEditingController messagecont = TextEditingController();
  var storegaref = Get.find<FirebaseController>().storage;
  final FocusNode fn = FocusNode();
  bool load = false;

  @override
  void dispose() {
    fn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Get.find<ThemeController>().thememode$.value == ThemeMode.dark ? MyThemes.darkTheme : MyThemes.lightTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.primaryContainer.withOpacity(0),
              ),
              child: Obx(() {
                if (roomcont.editedMessage$.value != null) {
                  fn.requestFocus();
                  messagecont.text = roomcont.editedMessage$.value!.messagetext!;
                }
                return Column(
                  children: [
                    Divider(
                      thickness: 1.5,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    if (roomcont.replying$.value)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                        child: Container(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 6),
                              Container(
                                
                                width: 5,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      roomcont.replymessage!.messagetext != null ? roomcont.replymessage!.messagetext! : 'photo',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  roomcont.clearReply();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant.withOpacity(1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        // IconButton(
                        //     onPressed: () {

                        //     },
                        //     icon: const Icon(Icons.emoji_emotions_outlined),
                        //   ),
                        Expanded(
                          child: TextField(
                            focusNode: fn,
                            controller: messagecont,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 10),
                              hintText: 'type here...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Color.fromARGB(0, 1, 1, 1),
                            ),
                            minLines: 1,
                            maxLines: 4,
                            onChanged: (t) {
                              // setState(() {});
                            },
                          ),
                        ),
                        if (roomcont.hasImage$.value)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            // child: Image.memory(roomcont.imagedata!, width: 30,),
                            child: TextButton.icon(
                              onPressed: () {
                                roomcont.clearImage();
                                setState(() {});
                              },
                              icon: const Icon(Icons.image_not_supported_outlined),
                              label: Image.memory(
                                roomcont.imagedata!,
                                width: 30,
                              ),
                            ),
                          ),
                        if (messagecont.text.isEmpty && !roomcont.hasImage$.value)
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      imageTile(
                                        ImageSource.gallery,
                                        'from gallery',
                                        Icons.image_search_rounded,
                                      ),
                                      imageTile(
                                        ImageSource.camera,
                                        'with camera',
                                        Icons.camera_alt_outlined,
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.camera),
                          ),
                        !load
                            ? IconButton(
                                onPressed: () async {
                                  if (roomcont.imagefile != null || messagecont.text.isNotEmpty) {
                                    setState(() {
                                      load = true;
                                    });
                                    if (roomcont.editedMessage$.value == null) {
                                      String? pathUrl = roomcont.imagefile != null ? await uploadImage(roomcont.imagefile!) : null;
                                      await roomcont.addMessage(
                                        {
                                          'messagetext': messagecont.text.isNotEmpty ? messagecont.text : null,
                                          'senttotokens': roomcont.thischatroom!.getOthersTokens(),
                                          'messageimageurl': pathUrl,
                                          'replymessage': roomcont.replymessage != null
                                              ? roomcont.replymessage!.active != null
                                                  ? !roomcont.replymessage!.active!
                                                      ? 'this message was deleted.'
                                                      : roomcont.replymessage!.messagetext
                                                  : roomcont.replymessage!.messagetext
                                              : null,
                                          // 'replymessage': roomcont.replymessage ?? null
                                          'replyauthorid': roomcont.replymessage != null ? roomcont.replymessage!.sentbyid : null,
                                          'replyimageurl': roomcont.replymessage != null ? roomcont.replymessage!.messageimageurl : null
                                        },
                                      );
                                      messagecont.clear();
                                      roomcont.clear();
                                    } else {
                                      await roomcont.updateMessage(messagecont.text);
                                      roomcont.editedMessage$.value = null;
                                      messagecont.clear();
                                      load = true;
                                    }
                                    setState(() {
                                      load = false;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.send),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(
                                  right: 10.0,
                                  left: 4,
                                ),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> pickImage(ImageSource source) async {
    var picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      var data = await picked.readAsBytes();
      return {
        'file': picked,
        'data': data,
      };
    }
    return null;
  }

  Future<String> uploadImage(XFile file) async {
    var data = await file.readAsBytes();
    await storegaref.ref(file.name).putData(data);
    return storegaref.ref(file.name).getDownloadURL();
  }

  ListTile imageTile(ImageSource src, String text, IconData icon) => ListTile(
        title: Text(text),
        leading: Icon(icon),
        onTap: () async {
          var im = await pickImage(src);
          if (im != null) {
            setState(() {
              roomcont.imagefile = im['file'];
              roomcont.imagedata = im['data'];
              roomcont.hasImage$.value = true;
            });
          }
          Navigator.of(context).pop();
        },
      );
}
