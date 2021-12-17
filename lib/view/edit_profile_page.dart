import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/view_model/auth_view_model.dart';
import 'package:uydu/widgets/auth_button.dart';
import 'package:uydu/widgets/auth_text_field.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class EditProfile extends StatefulWidget {
  var name, phone, adress;
  EditProfile({
    required this.name,
    required this.phone,
    required this.adress,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextStyleGenerator(
                  text: "Profili Düzenle",
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildNameTextField(),
              _buildPhoneTextField(),
              _buildAdressTextField(),
              _buildUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        maxLines: 1,
        titleText: "İsim",
        hintText: "${widget.name}",
        autofillHints: [AutofillHints.name],
        inputType: TextInputType.text,
        onChanged: (val) {
          setState(() {
            widget.name = val;
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
        hintText: "${widget.phone}",
        //autofillHints: [AutofillHints.telephoneNumber],
        inputType: TextInputType.number,
        onChanged: (val) {
          setState(() {
            widget.phone = val;
          });
        },
      ),
    );
  }

  Widget _buildAdressTextField() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthTextField(
        titleText: "Adres",
        hintText: "${widget.adress}",
        maxLines: 3,
        autofillHints: [AutofillHints.telephoneNumber],
        inputType: TextInputType.text,
        onChanged: (val) {
          setState(() {
            widget.adress = val;
          });
        },
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) => AuthButton(
        isActive: true,
        label: "Güncelle",
        onPressed: () {
          viewModel.onUpdateButtonPressed(
              context, widget.name, widget.phone, widget.adress);
        },
      ),
    );
  }
}
