import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/view_model/chats_view_model/chats_view_model.dart';
import 'package:uydu/view_model/language_view_model.dart';
import 'package:uydu/view_model/profile_view_model.dart';
import 'package:uydu/widgets/arc.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePageViewModel>(
      builder: (context, viewModel, child) => RefreshIndicator(
        backgroundColor: Colors.pink,
        color: Colors.white,
        onRefresh: () async {
          //await viewModel.initPage();
        },
        child: Scaffold(
          /*floatingActionButton: GetBuilder<LanguageController>(
            builder: (val) => FloatingActionButton(
              heroTag: 'herolang',
              onPressed: () {
                _changeLanguageModal(context);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  val.choosedLang == null
                      ? Icon(Icons.translate)
                      : Text(
                          val.choosedLang.toString().toUpperCase(),
                        ),
                ],
              ),
            ),
          ),*/
          backgroundColor: Colors.black,
          body: viewModel.profileState == ProfileState.Loading ||
                  viewModel.profileCategoryState == ProfileCategoryState.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorHelper.accentColor),
                  ),
                )
              : SafeArea(
                  child: _buildBody(context),
                ),
        ),
      ),
    );
  }

  _changeLanguageModal(context) async {
    await showDialog<String>(
      context: context,
      builder: (context) => GetBuilder<LanguageController>(
        builder: (val) => AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            width: MediaQuery.of(context).size.width - 50,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: val.languages.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      val.changeLanguage(context, val.languages[index]);
                      Navigator.pop(context);
                    });
                  },
                  child: Card(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Text(
                        val.languages[index].toUpperCase(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    ChatsViewModel chatsViewModel = Provider.of<ChatsViewModel>(context);
    return SingleChildScrollView(
      child: Consumer<ProfilePageViewModel>(
        builder: (context, viewModel, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackButton(),
            _buildProfilePhoto(),
            SizedBox(height: 20),
            _buildNameText(),
            if (!viewModel.isOwnProfile!)
              Center(
                child: GestureDetector(
                  onTap: () {
                    viewModel.makePay(context, viewModel.categories);
                  },
                  child: Container(
                    width: context.getDynmaicWidth(.4),
                    height: 40,
                    color: Colors.lightBlue,
                    child: Center(
                      child: TextStyleGenerator(
                        text: "Ödeme Yap",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (!viewModel.isOwnProfile!)
              Center(
                child: GestureDetector(
                  onTap: () {
                    chatsViewModel.startConversation(
                        viewModel.user!.userId, context);
                  },
                  child: Container(
                    width: context.getDynmaicWidth(.4),
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
                ),
              ),
            if (!viewModel.isOwnProfile!)
              Container(
                width: context.getDynmaicWidth(1),
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewModel.categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      title: TextStyleGenerator(
                        text: viewModel.categories[index]!.name,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Consumer<ProfilePageViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: CircleBorder(),
          color: ColorHelper.userProfilePageButtonColor,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: ColorHelper.userProfilePageSecondaryTextColor,
            onPressed: () {
              viewModel.onBackButtonPressed(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNameText() {
    return Consumer<ProfilePageViewModel>(
      builder: (context, viewModel, child) => Center(
        child: Column(
          children: [
            Text(
              viewModel.user?.displayName ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorHelper.userProfilePageTitleColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            if (viewModel.isOwnProfile!)
              Text(
                viewModel.user?.phone ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorHelper.userProfilePageTitleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: 8),
            Text(
              viewModel.user?.adress ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorHelper.userProfilePageTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (viewModel.isOwnProfile!)
              Container(
                width: context.getDynmaicWidth(1),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        viewModel.openIbanUpdate(
                            context, viewModel.user!.userId);
                      },
                      child: Container(
                        color: Colors.lightBlue,
                        padding: EdgeInsets.all(5),
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: context.getDynmaicWidth(.7),
                      child: TextStyleGenerator(
                          text: viewModel.iban!,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (viewModel.isOwnProfile!)
                  GestureDetector(
                    onTap: () {
                      viewModel.editProfile(
                          context,
                          viewModel.user!.displayName,
                          viewModel.user!.phone!,
                          viewModel.user!.adress!);
                    },
                    child: Container(
                      color: ColorHelper.accentColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Profili Güncelle",
                            style: TextStyle(
                              color: ColorHelper.userProfilePageTitleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (viewModel.isOwnProfile!) SizedBox(width: 16),
                if (viewModel.isOwnProfile!)
                  GestureDetector(
                    onTap: () {
                      viewModel.signOut(context);
                    },
                    child: Container(
                      color: ColorHelper.accentColor,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            "Çıkış Yap",
                            style: TextStyle(
                              color: ColorHelper.userProfilePageTitleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Consumer<ProfilePageViewModel>(
      builder: (context, viewModel, child) {
        double radius = MediaQuery.of(context).size.width / 6;
        double badgeHeight = MediaQuery.of(context).size.width / 11;
        double arcPadding = 8;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: radius * 2,
                    height: radius * 2,
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(arcPadding),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(radius),
                                ),
                              ),
                              child: Image.network(
                                viewModel.user?.photoUrl ?? '',
                                width: radius * 2,
                                height: radius * 2,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Arc(
                            radius: radius,
                            color: ColorHelper.accentColor,
                            startAngle: 0,
                            sweepAngle: 360,
                          ),
                        ),
                        if (viewModel.isOwnProfile!)
                          Positioned(
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor:
                                  ColorHelper.photoIconSelectedBackgroundColor,
                              child: Icon(
                                Icons.edit,
                                color: ColorHelper.photoIconSelectedColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (viewModel.isOwnProfile!)
                      viewModel.onProfilePhotoPressed(
                          context, viewModel.user!.photoUrl!, true);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
