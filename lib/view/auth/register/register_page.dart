import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/view_model/auth_view_model.dart';
import 'package:uydu/widgets/arc.dart';
import 'package:uydu/widgets/auth_button.dart';
import 'package:uydu/widgets/auth_text_field.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class RegisterPage extends StatefulWidget {
  final bool isArtisan;
  RegisterPage({
    required this.isArtisan,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var email, password, phone, adress, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 100,
            bottom: 100,
            left: 5,
            right: 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextStyleGenerator(
                  text: widget.isArtisan ? "Usta Kayıt" : "Müşteri Kayıt",
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _buildPhotoSelectBody(),
              SizedBox(height: 30),
              _buildEmailTextField(),
              SizedBox(height: 20),
              _buildPasswordTextField(),
              SizedBox(height: 20),
              _buildNameTextField(),
              SizedBox(height: 20),
              _buildPhoneTextField(),
              SizedBox(height: 20),
              _buildAdressTextField(),
              SizedBox(height: 0),
              if (widget.isArtisan)
                SizedBox(
                  child: Consumer<AuthViewModel>(
                    builder: (context, viewModel, child) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: viewModel.categories.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 0,
                            leading: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Checkbox(
                                checkColor: Colors.white,
                                value: viewModel.selectedCategories
                                    .contains(viewModel.categories[index]),
                                onChanged: (val) {
                                  viewModel.onSelectedCategory(
                                      viewModel.categories[index]!);
                                },
                              ),
                            ),
                            title: TextStyleGenerator(
                              text: viewModel.categories[index]!.name,
                              color: Colors.white,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthButton(
        isActive: true,
        label: "Kayıt Ol",
        onPressed: () {
          viewModel.singUpButtonOnPressed(context, email, password, name, phone,
              adress, widget.isArtisan, viewModel.selectedCategories);
        },
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        maxLines: 1,
        titleText: "Email",
        hintText: "Email adresinizi buraya giriniz",
        autofillHints: [AutofillHints.email],
        inputType: TextInputType.emailAddress,
        onChanged: (val) {
          setState(() {
            email = val;
          });
        },
      ),
    );
  }

  Widget _buildNameTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        maxLines: 1,
        titleText: "İsim",
        hintText: "İsminizi buraya giriniz",
        autofillHints: [AutofillHints.name],
        inputType: TextInputType.text,
        onChanged: (val) {
          setState(() {
            name = val;
          });
        },
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        maxLines: 1,
        titleText: "Telefon",
        hintText: "Telefon numaranızı buraya giriniz",
        //autofillHints: [AutofillHints.telephoneNumber],
        inputType: TextInputType.number,
        onChanged: (val) {
          setState(() {
            phone = val;
          });
        },
      ),
    );
  }

  Widget _buildAdressTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        titleText: "Adres",
        hintText: "Adresinizi buraya giriniz",
        maxLines: 3,
        autofillHints: [AutofillHints.addressCityAndState],
        inputType: TextInputType.text,
        onChanged: (val) {
          setState(() {
            adress = val;
          });
        },
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        maxLines: 1,
        obscureText: true,
        titleText: "Şifre",
        hintText: "Şifrenizi buraya giriniz",
        autofillHints: [AutofillHints.email],
        inputType: TextInputType.emailAddress,
        onChanged: (val) {
          setState(() {
            password = val;
          });
        },
      ),
    );
  }

  Widget _buildPhotoSelectBody() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        double radius = MediaQuery.of(context).size.width / 5;
        return GestureDetector(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            child: Stack(
              children: [
                Center(
                  child: viewModel.photoSelected
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(radius),
                              ),
                            ),
                            child: Image.file(
                              viewModel.photo!,
                              width: radius * 2,
                              height: radius * 2,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          child: Image.asset(
                            'assets/images/profile_photo_placeholder.png',
                            width: radius * 2,
                            height: radius * 2,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
                Container(
                  child: Arc(
                    radius: radius,
                    color: ColorHelper.accentColor,
                    startAngle: -5,
                    sweepAngle: 280,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: viewModel.photoSelected
                        ? ColorHelper.photoIconSelectedBackgroundColor
                        : ColorHelper.accentColor,
                    child: Icon(
                      viewModel.photoSelected ? Icons.edit : Icons.add,
                      color: viewModel.photoSelected
                          ? ColorHelper.photoIconSelectedColor
                          : ColorHelper.photoIconUnselectedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            viewModel.onProfilePhotoPressed(context);
          },
        );
      },
    );
  }
}
