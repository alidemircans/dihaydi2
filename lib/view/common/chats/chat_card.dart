import 'package:flutter/material.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/widgets/imaged_container_widget.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class ChatCard extends StatelessWidget {
  final Chat? chat;
  final String? dateFilter;
  final String? hour;
  final String? minute;
  ChatCard({
    required this.chat,
    required this.dateFilter,
    required this.hour,
    required this.minute,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      width: context.getDynmaicWidth(1),
      height: context.getDynmaicHeight(.12),
      decoration: BoxDecoration(
        color: ColorHelper.chatCardBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: _buildChatCardView(context),
    );
  }

  Container _buildChatCardView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: context.getDynmaicWidth(1),
      child: Row(
        children: [
          _buildUserProfileImage(context),
          SizedBox(
            width: context.getDynmaicWidth(.03),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextStyleGenerator(
                          text: chat!.user!.displayName,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        if (chat!.unReadMessageCount != 0 &&
                            chat!.unReadMessageCount != null)
                          Container(
                            width: context.getDynmaicWidth(.07),
                            height: context.getDynmaicWidth(.07),
                            decoration: BoxDecoration(
                              color: ColorHelper.primarySwatch,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: TextStyleGenerator(
                                text: chat!.unReadMessageCount.toString(),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: context.getDynmaicHeight(0.01),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        chat!.isPic
                            ? Expanded(
                                child: Row(
                                  children: [
                                    TextStyleGenerator(
                                      text: chat!.isOwnMessage ? "Sen:" : "",
                                      color: chat!.unReadMessageCount != 0 &&
                                              chat!.unReadMessageCount != null
                                          ? ColorHelper.chatCardPink
                                          : ColorHelper.chatTextGrey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      maxLine: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.image,
                                        color: ColorHelper.chatTextGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: TextStyleGenerator(
                                  text: chat!.isOwnMessage
                                      ? "Sen: ${chat!.message}"
                                      : chat!.message,
                                  color: chat!.unReadMessageCount != 0 &&
                                          chat!.unReadMessageCount != null
                                      ? ColorHelper.chatCardPink
                                      : ColorHelper.chatTextGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                        Container(
                          padding: EdgeInsets.only(left: 4),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              TextStyleGenerator(
                                text: "$dateFilter, ",
                                color: ColorHelper.chatTextGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                maxLine: 1,
                              ),
                              TextStyleGenerator(
                                text: " $hour:$minute",
                                color: ColorHelper.chatTextGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                maxLine: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImagedContainerGeneratorWidget _buildUserProfileImage(BuildContext context) {
    return ImagedContainerGeneratorWidget(
      imageUrl: chat!.user!.photoUrl.toString(),
      borderColor: ColorHelper.navigationBarBackgroundColor,
      borerRadiusWidth: 0,
      width: context.getDynmaicWidth(.15),
      height: context.getDynmaicWidth(.15),
      isNetworkImage: true,
    );
  }
}
