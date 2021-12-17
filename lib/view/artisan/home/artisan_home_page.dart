import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/view_model/artisan_home_view_model.dart';
import 'package:uydu/view_model/customer_home_view_model.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class ArtisanHomePage extends StatelessWidget {
  const ArtisanHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var artisanViewModel =
        Provider.of<ArtisanHomeViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: TextStyleGenerator(
          text: "Hizmet verdiğiniz kategoriler",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                artisanViewModel.openProfilePage(context);
              },
              child: Icon(
                Icons.person_outline,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                artisanViewModel.openAllChatsPage(context);
              },
              child: Icon(
                Icons.message,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Consumer<ArtisanHomeViewModel>(
        builder: (context, viewModel, child) => RefreshIndicator(
          backgroundColor: Colors.pink,
          color: Colors.white,
          onRefresh: () async {
            viewModel.initPage();
          },
          child: _buildJobsList(),
        ),
      ),
    );
  }

  Widget _buildJobsList() {
    return Consumer<ArtisanHomeViewModel>(
      builder: (context, viewModel, child) => viewModel.categories.isEmpty
          ? ListView(children: [
              Center(
                child: TextStyleGenerator(
                  text: "Kategori Listesi Boş",
                  color: Colors.black,
                ),
              )
            ])
          : Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.categories.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          horizontalTitleGap: 0,
                          leading: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.black,
                            ),
                            child: Checkbox(
                              checkColor: Colors.black,
                              value: viewModel.selectedCategories
                                  .contains(viewModel.categories[index]!.id),
                              onChanged: (val) {
                                viewModel.onSelectedCategory(
                                    viewModel.categories[index]!.id);
                              },
                            ),
                          ),
                          title: TextStyleGenerator(
                            text: viewModel.categories[index]!.name,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.updateCategories(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        width: context.getDynmaicWidth(.4),
                        color: Colors.blue,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child:
                              viewModel.categoriesState == CategoryState.Loading
                                  ? TextStyleGenerator(
                                      text: "-",
                                      color: Colors.white,
                                    )
                                  : TextStyleGenerator(
                                      text: "Güncelle",
                                      color: Colors.white,
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
