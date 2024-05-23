import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/services/firebase_services/messaging_service.dart';
import 'package:social_ice/widgets/chat_widgets/chat_message_widget.dart';
import 'package:social_ice/widgets/chat_widgets/chat_textfield.dart';
import 'package:social_ice/widgets/chat_widgets/show_document_message.dart';
import 'package:social_ice/widgets/chat_widgets/show_media_message.dart';

class ChattingScreen extends StatefulWidget {
  final UserModel chattingWith;
  final String chatId;
  const ChattingScreen(
      {super.key, required this.chatId, required this.chattingWith});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final messageController = TextEditingController();
  final String currentUserId = FirebaseServices.auth.currentUser!.uid;
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (focusNode.hasFocus) {
          // Keyboard is open, but don't dismiss it if the user is scrolling
          return;
        }
        // Otherwise, dismiss the keyboard
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Get.to(() => ProfileScreenBuilder(uid: widget.chattingWith.uid!));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      widget.chattingWith.profilePicUrl.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.chattingWith.name.toString(),
                        textScaler: const TextScaler.linear(0.9),
                      ),
                      Text("@${widget.chattingWith.username}",
                          textScaler: const TextScaler.linear(0.7))
                    ],
                  ),
                )
              ],
            ),
          ),
          forceMaterialTransparency: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseServices.firestore
                      .collection("chats")
                      .doc(widget.chatId)
                      .collection("messages")
                      .orderBy("timestamp")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                      return Flexible(
                        child: ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              ChatMessage chatData = ChatMessage.fromSnapshot(
                                  snapshot.data!.docs[index]);

                              switch (chatData.fileType) {
                                case Filetype.image || Filetype.video:
                                  return ShowMediaMessage(
                                      chatMessage: chatData);
                                case Filetype.document:
                                  return ShowDocumentMessage(
                                      chatMessage: chatData);
                                default:
                                  return ChatMessageWidget(message: chatData);
                              }
                            }),
                      );
                    } else {
                      return const Text('Something went wrong');
                    }
                  }),
            ),
            Row(
              children: [
                Flexible(
                  flex: 9,
                  child: ChatTextfield(
                    controller: messageController,
                    hintText: "Write a message",
                    chatId: widget.chatId,
                    chattingWithId: widget.chattingWith.uid.toString(),
                  ),
                ),
                Flexible(
                    child: IconButton(
                        onPressed: () {
                          if (messageController.text.isEmpty) {
                          } else {
                            try {
                              String timeStamp = DateTime.now().toString();
                              String messageId = currentUserId +
                                  DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                              ChatMessage message = ChatMessage(
                                  messageId: messageId,
                                  senderId: currentUserId,
                                  content: messageController.text,
                                  timestamp: timeStamp,
                                  fileType: Filetype.text,
                                  filename: "text");
                              MessagingServices().sendMessage(
                                  widget.chatId,
                                  message,
                                  messageId,
                                  timeStamp,
                                  widget.chattingWith.uid!);
                              messageController.clear();
                            } catch (exp) {
                              if (kDebugMode) {
                                print("Error");
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.send_rounded)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
