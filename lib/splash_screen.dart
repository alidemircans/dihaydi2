import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/view_model/splash_screen_view_model.dart';

class SplashPage extends StatelessWidget {
  final Duration _animationDuration = Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    _navigate(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Consumer<SplashViewModel>(
                  builder: (ctx, viewModel, child) => AnimatedContainer(
                    duration: _animationDuration,
                    margin: EdgeInsets.only(
                      top: viewModel.state == SplashViewState.Animated ? 0 : 50,
                      bottom:
                          viewModel.state == SplashViewState.Animated ? 100 : 0,
                    ),
                    width: viewModel.state == SplashViewState.Animated
                        ? MediaQuery.of(context).size.width * (0.65)
                        : MediaQuery.of(context).size.width * (0.5),
                    child: Image.asset(
                      "assets/images/wingding_logo.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            _buildButton(_buildStartButton()),
            SizedBox(height: 16),
            _buildButton(_buildCustomerButton()),
            _buildButton(_buildSignInButton()),
          ],
        ),
      ),
    );
  }

  _navigate(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      SplashViewModel viewModel = Provider.of<SplashViewModel>(
        context,
        listen: false,
      );
      viewModel.navigate(context);
    });
  }

  Widget _buildButton(Widget buttonBody) {
    return Consumer<SplashViewModel>(
      builder: (ctx, viewModel, child) => AnimatedOpacity(
        duration: _animationDuration,
        opacity: viewModel.state == SplashViewState.Animated ? 1 : 0,
        child: Container(
          width: double.infinity,
          child: buttonBody,
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton(
          child: Text(
            "Esnaf",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: ColorHelper.notificationCardBackgroundColor,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                vertical: 20,
              )),
          onPressed: () {
            viewModel.openRegisterPage(context,true);
          },
        ),
      ),
    );
  }

  Widget _buildCustomerButton() {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ElevatedButton(
          child: Text(
            "Müşteri",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
              primary: ColorHelper.notificationCardBackgroundColor,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                vertical: 20,
              )),
          onPressed: () {
            viewModel.openRegisterPage(context,false);
          },
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) => Container(
        margin: EdgeInsets.only(bottom: 30),
        child: TextButton(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "Zaten hesabın varmı?",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorHelper.splashSecondaryButtonColor,
                  ),
                ),
                TextSpan(
                  text: " Giriş Yap",
                  style: TextStyle(color: ColorHelper.accentColor),
                ),
              ],
            ),
          ),
          onPressed: () {
            viewModel.openLoginPage(context);
          },
        ),
      ),
    );
  }
}
