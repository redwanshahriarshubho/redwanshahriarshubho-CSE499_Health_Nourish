import 'package:flutter/material.dart';
import 'package:health_nourish/presentation/loading_screen/loading_screen.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../providers/web_socket_provider.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../six_screen/six_screen.dart';
import '../five_screen/five_screen.dart';

class FourScreen extends StatefulWidget {
  FourScreen({Key? key}) : super(key: key);

  @override
  _FourScreenState createState() => _FourScreenState();
}

class _FourScreenState extends State<FourScreen> {
  TextEditingController messageController = TextEditingController();
  List<String> messages = [];
  Stream? webSocketStream;

  @override
  void initState() {
    super.initState();

    // Initial welcome message
    messages.add(
        "I'd be glad to help you create a muscle-building diet plan for seven days! "
            "In order to make sure each meal provides the necessary nutrients, I've designed three meals per day "
            "with a good balance of protein, carbs, and healthy fats."
    );
  }

  void sendMessage(BuildContext context) {
    String message = messageController.text;
    if (message.isNotEmpty) {
      final webSocketProvider = Provider.of<WebSocketProvider>(context, listen: false);

      webSocketProvider.sendMessage(message);

      setState(() {
        messages.add("You: $message");
        messages.add("AI is typing...");
        messageController.clear();
      });

      if (webSocketStream == null) {
        // Subscribe to the stream
        webSocketStream = webSocketProvider.webSocketStream;
        webSocketStream?.listen(
              (responseMessage) {
            debugPrint("Received response: $responseMessage");
            handleWebSocketResponse(responseMessage);
          },
          onError: (error) {
            debugPrint("Stream error: $error");
          },
          cancelOnError: true,
        );
      }
    }
  }

  void handleWebSocketResponse(String responseMessage) {
    // Simulate a delay for "AI is typing..." animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (messages.isNotEmpty && messages.last == "AI is typing...") {
          messages.removeLast();  // Remove typing indicator
        }
        messages.add("AI: $responseMessage");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true, // Allow resizing when the keyboard appears
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: appTheme.pink5001,
            image: DecorationImage(
              image: AssetImage(ImageConstant.imgFour),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 137.h,
                  height: 30.v,
                  margin: EdgeInsets.only(left: 53.h),
                  child: Text(
                    "Chat with our\n",
                    maxLines: null,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              SizedBox(height: 2.v),
              Container(
                width: 319.h,
                height: 50.v,
                margin: EdgeInsets.only(left: 52.h, right: 58.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "AI Based Health Assistant\n",
                        style: theme.textTheme.headlineSmall,
                      ),
                      TextSpan(
                        text: "\n",
                        style: CustomTextStyles.headlineSmallSemiBold,
                      )
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 21.v),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isUserMessage = message.startsWith("You:");
                    return MessageBubble(
                      message: message,
                      isUserMessage: isUserMessage,
                    );
                  },
                ),
              ),
              SizedBox(height: 10.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 31.h, vertical: 16.v),
                child: CustomTextFormField(
                  controller: messageController,
                  hintText: "Type your message",
                  textInputAction: TextInputAction.done,
                  suffix: GestureDetector(
                    onTap: () {
                      sendMessage(context);
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(12.h, 7.v, 28.h, 7.v),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgSave,
                        height: 25.adaptSize,
                        width: 25.adaptSize,
                      ),
                    ),
                  ),
                  suffixConstraints: BoxConstraints(maxHeight: 49.v),
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0) _buildColumnFiMessage(context),

            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildColumnFiMessage(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 90.h,
      vertical: 10.v,
    ),
    decoration: AppDecoration.gradientPrimaryContainerToPink,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.v),
        Container(
          margin: EdgeInsets.only(right: 14.h),
          padding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 11.v,
          ),
          decoration: AppDecoration.outlinePrimary1.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder39,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                height: 57.adaptSize,
                width: 57.adaptSize,
                padding: EdgeInsets.all(16.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgFiMessageSquare,
                ),
              ),
              Spacer(flex: 40),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const LoadingScreen();
                    },
                  );
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FiveScreen(),
                      ),
                    );
                  });
                },
                child: CustomImageView(
                  imagePath: ImageConstant.imgFiBookmark,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(top: 17.v, bottom: 16.v),
                ),
              ),
              Spacer(flex: 59),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const LoadingScreen();
                    },
                  );
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SixScreen(),
                      ),
                    );
                  });
                },
                child: CustomImageView(
                  imagePath: ImageConstant.imgFiGitlab,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(top: 17.v, right: 16.h, bottom: 16.v),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isUserMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          isUserMessage ? 80.h : 48.h,
          8.v,
          isUserMessage ? 48.h : 80.h,
          8.v,
        ),
        padding: EdgeInsets.all(12.0),
        width: 280.h,
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: isUserMessage ? Radius.circular(12) : Radius.circular(0),
            bottomRight: isUserMessage ? Radius.circular(0) : Radius.circular(12),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}