import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milky/controllers/chat_room_controller.dart';
import 'package:milky/controllers/firebase_controller.dart';
import 'package:milky/controllers/settings_controller.dart';
import 'package:milky/models/chatroom_model.dart';
import 'package:milky/models/color_schemes.dart';
import 'package:milky/models/message_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milky/screens/image_view_screen.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final Message thismessage;
  const MessageBubble({
    Key? key,
    required this.thismessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Provider.of<ThemeProvider>(context, listen: false).isDarkmode ? MyThemes.darkTheme : MyThemes.lightTheme;
    final roomcont = Get.find<ChatRoomController>();
    final rad = Get.find<SettingsController>().getRadius();
    final size = Get.find<SettingsController>().getSize();
    return Align(
      // padding: const EdgeInsets.all(8.0),
      alignment: thismessage.sentByMe() ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          if ((thismessage.active != null ? thismessage.active! : thismessage.active == null) && thismessage.sentByMe()) {
            showDialog(context: context, builder: (_) => dialog(roomcont, context));
          }
        },
        child: Container(
          // alignment: thismessage.sentbyid == Get.find<FirebaseController>().myid ? Alignment.centerRight : Alignment.centerLeft,
          constraints: BoxConstraints(
            maxWidth: thismessage.messageimageurl != null ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.85,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: thismessage.sentByMe() ? Radius.circular(rad!) : const Radius.circular(0),
                  topRight: thismessage.sentByMe() ? const Radius.circular(0) : Radius.circular(rad!),
                  bottomLeft: Radius.circular(rad!),
                  bottomRight: Radius.circular(rad)),
              color: thismessage.sentByMe() ? theme.colorScheme.secondary : theme.colorScheme.tertiary),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.all(5),
          child: (thismessage.active != null ? thismessage.active! : thismessage.active == null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (roomcont.thischatroom!.purpose != RoomPurpose.chat)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          thismessage.sentbyid == Get.find<FirebaseController>().currentUser!.id
                              ? 'You'
                              : roomcont.thischatroom!.roomusers[thismessage.sentbyid]!.nickname,
                          style: TextStyle(fontSize: size! - 1, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (thismessage.replymap != null)
                      IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.2),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            color: Color.fromARGB(150, 38, 124, 194),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                // const SizedBox(width: 3),
                                Container(
                                  width: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(255, 88, 255, 94),
                                  ),
                                  // height: 35,
                                ),
                                const SizedBox(width: 2),
                                if (thismessage.replymap!['image'] != null)
                                  Image.network(
                                    thismessage.replymap!['image'],
                                    height: 30,
                                  ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        roomcont.thischatroom!.purpose != RoomPurpose.chat
                                            ? Text(
                                                roomcont.thischatroom!.roomusers[thismessage.replymap!['authorid']]!.nickname,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size! - 2),
                                              )
                                            : const SizedBox(),
                                        if (thismessage.replymap!['message'] != null)
                                          Text(
                                            thismessage.replymap!['message']!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: size! - 2),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (thismessage.messageimageurl != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(rad - 2),
                          // child: Image.network(
                          //   thismessage.messageimageurl!,
                          // ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ImageViewScreen(imageurl: thismessage.messageimageurl!),
                                ),
                              );
                            },
                            // child: FutureBuilder<bool>(
                            //     future: thismessage.imageDownloaded(),
                            //     builder: (context, snapshot) {
                            //       if (!snapshot.hasData) {
                            //         return Container(
                            //             color: Colors.green,
                            //         );
                            //       }
                            //       return snapshot.data!
                            //           ? Image.memory(
                            //               thismessage.imagebytes!,
                            //               fit: BoxFit.cover,
                            //             )
                            //           : FadeInImage.assetNetwork(
                            //               placeholder: 'assets/loadingimage.png',
                            //               placeholderFit: BoxFit.cover,
                            //               placeholderScale: 0.1,
                            //               image: thismessage.messageimageurl!,
                            //             );
                            //     }),

                            // child: FadeInImage.assetNetwork(
                            //   placeholder: 'assets/loadingimage.png',
                            //   placeholderFit: BoxFit.cover,
                            //   placeholderScale: 0.1,
                            //   image: thismessage.messageimageurl!,
                            // ),

                            child: thismessage.imagebytes == null
                                ? FadeInImage.assetNetwork(
                                    placeholder: 'assets/loadingimage.png',
                                    placeholderFit: BoxFit.cover,
                                    placeholderScale: 0.1,
                                    image: thismessage.messageimageurl!,
                                  )
                                : Image.memory(thismessage.imagebytes!),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 4, top: thismessage.messageimageurl != null ? 0 : 3),
                      child: thismessage.messagetext != null
                          ? Text(
                              thismessage.messagetext!,
                              style: TextStyle(fontSize: size),
                            )
                          : null,
                    ),
                    Text(
                      DateFormat.Hm().format(thismessage.timestamp),
                      style: TextStyle(fontSize: size! - 3),
                    )
                  ],
                )
              : Text(
                  'this message was deleted.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: size!,
                  ),
                ),
        ),
      ),
    );
  }

  Widget dialog(ChatRoomController c, BuildContext context) => AlertDialog(
        title: const Text('message options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('delete message'),
              trailing: const Icon(Icons.delete_outline_rounded),
              onTap: () {
                c.deactivateMessage(thismessage);
              },
            ),
            ListTile(
              title: const Text('copy message'),
              trailing: const Icon(Icons.copy_rounded),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: thismessage.messagetext),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            label: const Text('close'),
          )
        ],
      );
}
