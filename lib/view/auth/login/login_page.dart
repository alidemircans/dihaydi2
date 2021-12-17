import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/view_model/auth_view_model.dart';
import 'package:uydu/widgets/arc.dart';
import 'package:uydu/widgets/auth_button.dart';
import 'package:uydu/widgets/auth_text_field.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            top: 100,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:  TextStyleGenerator(
                  text: "Giriş Yap",
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _buildEmailTextField(),
              SizedBox(height: 20),
              _buildPasswordTextField(),
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
        label: "Giriş Yap",
        onPressed: () {
          viewModel.signInWithEmailAndPassword(context, email, password);
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

  Widget _buildPasswordTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        obscureText: true,
        titleText: "Şifre",
        maxLines: 1,
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
