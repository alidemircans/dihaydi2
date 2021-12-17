import 'package:flutter/material.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart' as svg;

class CheckOutPage extends StatefulWidget {
  CategoryModel? categoryModel;

  CheckOutPage({required this.categoryModel});
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  var number = 3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(249, 249, 251, 1),
        bottomNavigationBar: _payNowButton(context),
        body: SingleChildScrollView(
          child: Container(
            height: context.getDynmaicHeight(1),
            child: Column(
              //  physics: NeverScrollableScrollPhysics(),
              children: [
                _buildCheckOutTopArea(context),
                SizedBox(
                  height: 10,
                ),
                _bagDetailArea(context),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: context.getDynmaicWidth(.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyleGenerator(
                        text: "Kartın Üzerinde Yazan İsim",
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: context.getDynmaicWidth(.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextStyleGenerator(
                        text: "Kart Numarası",
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 15),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: context.getDynmaicWidth(.9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyleGenerator(
                              text: "Ay",
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: context.getDynmaicWidth(.2),
                              height: context.getDynmaicWidth(.2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextStyleGenerator(
                                      text: "-",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyleGenerator(
                              text: "Yıl",
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: context.getDynmaicWidth(.2),
                              height: context.getDynmaicWidth(.2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextStyleGenerator(
                                      text: "-",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                  RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextStyleGenerator(
                              text: "CVV",
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              width: context.getDynmaicWidth(.3),
                              height: context.getDynmaicWidth(.2),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  buildCounter: (BuildContext context,
                                          {int? currentLength,
                                          int? maxLength,
                                          bool? isFocused}) =>
                                      null,
                                  maxLength: 3,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: context.getDynmaicWidth(.25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(),
                            Center(
                              child: Container(
                                width: context.getDynmaicWidth(.1),
                                height: context.getDynmaicWidth(.1),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.orange, width: 3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: Center(
                                  child: TextStyleGenerator(
                                    text: "?",
                                    fontSize: 22,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _bagDetailArea(BuildContext context) {
    return Container(
      width: context.getDynmaicWidth(.9),
      // height: context.getDynmaicHeight(.3),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.getDynmaicHeight(.01),
          ),
          Container(
            height: context.getDynmaicHeight(.08),
            child: Center(
              child: ListTile(
                title: TextStyleGenerator(
                  text: "Alınacak Hizmet",
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                subtitle: TextStyleGenerator(
                  text: widget.categoryModel!.name.toString(),
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            height: context.getDynmaicHeight(.12),
            child: Center(
              child: ListTile(
                title: TextStyleGenerator(
                  text: "Toplam",
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
                trailing: TextStyleGenerator(
                  text: widget.categoryModel!.price.toString() + "TL",
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _payNowButton(BuildContext context) {
    return Container(
      width: context.getDynmaicWidth(.5),
      margin: EdgeInsets.symmetric(
          horizontal: context.getDynmaicWidth(.07), vertical: 10),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: TextStyleGenerator(
          text: "Şimdi Öde",
          color: Colors.white,
        ),
      ),
    );
  }

  Container _buildCheckOutTopArea(BuildContext context) {
    return Container(
      // height: context.getDynmaicHeight(.3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.01, 0.9],
          colors: [
            Colors.purple,
            Colors.lightBlue,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 20),
            height: context.getDynmaicHeight(.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                TextStyleGenerator(
                  text: "Ödeme Sayfası",
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
                SizedBox(),
              ],
            ),
          ),
          Container(
            width: context.getDynmaicWidth(.8),
            height: 100,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.orange,
                    ),
                    padding: EdgeInsets.only(left: 20),
                    width: context.getDynmaicWidth(.75),
                    height: 90,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: TextStyleGenerator(
                          text: "Ödeme \n Detayları",
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: svg.SvgPicture.asset(
                    'assets/images/onboarding/creditcard.svg',
                    height: context.getDynmaicHeight(.25),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
