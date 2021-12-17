
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/view_model/chats_view_model/chats_view_model.dart';
import 'package:uydu/view_model/list_artisan_by_category_view_model.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class ListArtisanByCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatsViewModel chatsViewModel = Provider.of<ChatsViewModel>(context);
    return Consumer<ListArtisanByCategorViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextStyleGenerator(
              text: "Çevrendekiler",
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          body: ListView.builder(
            itemCount: viewModel.users.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey[300],
                child: Column(
                  children: [
                    Container(
                      width: context.getDynmaicWidth(1),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                          child: Image.network(
                            viewModel.users[index]!.photoUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: TextStyleGenerator(
                          text: viewModel.users[index]!.displayName,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: TextStyleGenerator(
                          text: viewModel.users[index]!.phone,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        chatsViewModel.startConversation(
                            viewModel.users[index]!.userId, context);
                      },
                      child: Container(
                        //  width: context.getDynmaicWidth(.),
                        height: 40,
                        color: Colors.lightBlue,
                        child: Center(
                          child: TextStyleGenerator(
                            text: "Mesaj At",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
