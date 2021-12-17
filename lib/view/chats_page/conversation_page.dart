import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/model/message.dart';
import 'package:uydu/view_model/chats_view_model/conversation_view_model.dart';
import 'package:uydu/widgets/imaged_container_widget.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class ConversationPage extends StatefulWidget {
  final Chat? chat;
  ConversationPage({
    required this.chat,
  });

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 0, right: 0, bottom: 0),
        child: _buildBody(context),
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              _buildBackButton(context),
              _buildConversationPersonCard(),
            ],
          ),
        ),
        _buildSpacer(context),
        Expanded(child: _buildMessagesList(context)),
        _buildBottomBar()
      ],
    );
  }

  _buildBottomBar() {
    return Container(
      color: ColorHelper.chatCardBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: 90,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 14),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: ColorHelper.chatBackgrounGrey,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(25),
                    right: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Bir mesaj yaz..",
                          hintStyle: TextStyle(
                            color: ColorHelper.chatTextGrey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Consumer<ConversationViewModel>(
                      builder: (context, viewModel, child) => InkWell(
                        onTap: () {
                          viewModel.getImagesFromCamera(
                              context,
                              widget.chat!.id,
                              widget.chat!.senderId!,
                              widget.chat!.user!.userId);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Icon(
                            Icons.photo_camera,
                            color: ColorHelper.chatTextGrey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Consumer<ConversationViewModel>(
            builder: (context, viewModel, child) => InkWell(
              onTap: () {
                if (_controller.value.text == '') return;
                viewModel.sendNewMessage(
                  widget.chat!.id,
                  Message(
                    content: _controller.value.text.toString(),
                    senderId: "",
                    receiverId: widget.chat!.user!.userId.toString(),
                    isPic: false,
                    isSystemMessage: false,
                  ),
                );
                _controller.clear();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/icons/dm-box-send-icon.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    BuildContext context,
  ) {
    return Consumer<ConversationViewModel>(
      builder: (context, viewModel, child) => StreamBuilder<List<Message?>>(
        stream: viewModel.getSingleConversation(widget.chat!.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              reverse: true,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.reversed.map((e) {
                return e!.isSystemMessage
                    ? _buildSystemMessageCard(e)
                    : e.isPic
                        ? _buildImageMessageCard(e)
                        : _buildMessageCard(e);
              }).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildImageMessageCard(Message e) {
    return Consumer<ConversationViewModel>(
      builder: (context, viewModel, child) => Align(
        alignment:
            e.isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: InkWell(
          onTap: () => viewModel.openImageReveviewPage(context, e.content),
          child: Container(
            width: context.getDynmaicWidth(.5),
            height: context.getDynmaicWidth(.5),
            margin: e.isOwnMessage
                ? EdgeInsets.only(left: 40, right: 16, bottom: 10)
                : EdgeInsets.only(right: 40, left: 16, bottom: 10),
            decoration: BoxDecoration(
              color: e.isOwnMessage
                  ? ColorHelper.chatCardPink
                  : ColorHelper.chatCardBackgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(e.content),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemMessageCard(Message e) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: TextStyleGenerator(
          text: e.content.toString(),
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageCard(Message message) {
    return Align(
      alignment:
          message.isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: message.isOwnMessage
            ? EdgeInsets.only(left: 40, right: 16, bottom: 10)
            : EdgeInsets.only(right: 40, left: 16, bottom: 10),
        decoration: BoxDecoration(
          color: message.isOwnMessage
              ? ColorHelper.chatCardPink
              : ColorHelper.chatCardBackgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: TextStyleGenerator(
          text: message.content.toString(),
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildConversationPersonCard() {
    return Consumer<ConversationViewModel>(
        builder: (context, viewModel, child) {
      return InkWell(
        onTap: () {
          viewModel.openProfilePage(context, widget.chat!.user!.userId);
        },
        child: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagedContainerGeneratorWidget(
                height: 50,
                width: 50,
                imageUrl: widget.chat!.user!.photoUrl.toString(),
                borderColor: Colors.transparent,
                borerRadiusWidth: 0,
                isNetworkImage: true,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextStyleGenerator(
                  text: widget.chat!.user!.displayName,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSpacer(BuildContext context) {
    return SizedBox(
      height: context.getDynmaicHeight(.01),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Card(
      shape: CircleBorder(),
      color: ColorHelper.chatBackgrounGrey,
      child: Consumer<ConversationViewModel>(
        builder: (ctx, viewModel, child) => IconButton(
          icon: Icon(Icons.arrow_back),
          color: ColorHelper.authTextFieldTitleColor,
          onPressed: () {
            viewModel.onBackButtonPressed(context);
          },
        ),
      ),
    );
  }
}
