import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/model/chat.dart';
import 'package:uydu/view/common/chats/chat_card.dart';
import 'package:uydu/view_model/chats_view_model/chats_view_model.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsPageState createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 32, left: 16, right: 16),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(context),
          _buildSpacer(context),
          _buildChatsTitle(),
          _buildSpacer(context),
          _buildChatsListView(context),
        ],
      ),
    );
  }

  Widget _buildChatsListView(
    BuildContext context,
  ) {
    return Consumer<ChatsViewModel>(
      builder: (context, viewModel, child) {
        return StreamBuilder<List<Chat?>>(
          stream: viewModel.getAllConversation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10),
                          child: TextStyleGenerator(
                            text:
                                "Şu anda hiç mesajınız yok!",
                            color: Colors.white,
                            alignment: TextAlign.center,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data!.map((e) {
                        List filteredData = viewModel.getDataFilter(e!.sentAt);

                        return GestureDetector(
                          onTap: () {
                            viewModel.openConversationPage(context, e);
                          },
                          child: ChatCard(
                            chat: e,
                            dateFilter: filteredData[0].toString(),
                            hour: filteredData[1].toString(),
                            minute: filteredData[2].toString(),
                          ),
                        );
                      }).toList(),
                    );
            } else if (snapshot.hasError) {
              return Center(
                  child: TextStyleGenerator(
                text: "Bir sorun oluştur ${snapshot.error}",
                color: Colors.white,
              ));
            } else {
              print("Veri yok");
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  Container _buildChatsTitle() {
    return Container(
      child: TextStyleGenerator(
        text: "Mesajlar",
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSpacer(BuildContext context) {
    return SizedBox(
      height: context.getDynmaicHeight(.05),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Card(
      shape: CircleBorder(),
      color: ColorHelper.authTextFieldFillColor,
      child: Consumer<ChatsViewModel>(
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
