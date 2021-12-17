import 'package:flutter/material.dart';
import 'package:uydu/model/customer_request_model.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class RequestCard extends StatefulWidget {
  CustomerRequestModel? customerRequestModel;
  String? userId;

  Function() seeUserProfile;
  Function()? goToCustomer;
  Function()? finsihJob;
  Function()? changeToEstimateDate;
  Function()? rateArtisan;

  RequestCard({
    required this.customerRequestModel,
    required this.userId,
    required this.seeUserProfile,
    this.finsihJob,
    this.changeToEstimateDate,
    this.goToCustomer,
    this.rateArtisan,
  });

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          if (widget.customerRequestModel!.status == 5)
            Container(
              color: Colors.redAccent,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: widget.customerRequestModel!.artisanId == widget.userId
                      ? "Bu Müşteriye gidiyorsun"
                      : "Usta Geliyor",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.customerRequestModel!.status == 3)
            Container(
              color: Colors.redAccent,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: "İş İptal Edilmiş",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.customerRequestModel!.status == 0)
            Container(
              color: Colors.green,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: "İş Teslim Edilmiş",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.customerRequestModel!.status == 1)
            Container(
              color: Colors.green,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: "Parça Tamirde",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.customerRequestModel!.status == 2)
            Container(
              color: Colors.redAccent,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: "Parça Müşteriden Alınmayı Bekliyor",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (widget.customerRequestModel!.status == 4)
            Container(
              color: Colors.green,
              height: 30,
              width: context.getDynmaicWidth(1),
              child: Center(
                child: TextStyleGenerator(
                  text: "Yeni İş",
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.customerRequestModel!.status == 0 ||
                      widget.customerRequestModel!.status == 1 ||
                      widget.customerRequestModel!.status == 2 ||
                      widget.customerRequestModel!.status == 3 ||
                      widget.customerRequestModel!.status == 4 ||
                      widget.customerRequestModel!.status == 5
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    )
                  : BorderRadius.all(
                      Radius.circular(10),
                    ),
            ),
            width: context.getDynmaicWidth(1),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: context.getDynmaicWidth(.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 16),
                            child: Row(
                              children: [
                                TextStyleGenerator(
                                  text: "Kategori : ",
                                  fontWeight: FontWeight.bold,
                                ),
                                TextStyleGenerator(
                                  text:
                                      "${widget.customerRequestModel!.categoryName}",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8),
                            child: Row(
                              children: [
                                TextStyleGenerator(
                                  text: "Marka : ",
                                  fontWeight: FontWeight.bold,
                                ),
                                TextStyleGenerator(
                                  text:
                                      "${widget.customerRequestModel!.brandName}",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8),
                            child: Row(
                              children: [
                                TextStyleGenerator(
                                  text: "Model : ",
                                  fontWeight: FontWeight.bold,
                                ),
                                TextStyleGenerator(
                                  text:
                                      "${widget.customerRequestModel!.modelName}",
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: context.getDynmaicWidth(.35),
                          padding: const EdgeInsets.only(right: 5.0, top: 16),
                          child: Container(
                            width: context.getDynmaicWidth(.35),
                            child: TextStyleGenerator(
                              text:
                                  "Talep Tarih : ${widget.customerRequestModel!.sentAt.toString().substring(0, 16)}",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: context.getDynmaicWidth(.35),
                          padding: const EdgeInsets.only(right: 5.0, top: 5),
                          child: Container(
                            width: context.getDynmaicWidth(.35),
                            child: TextStyleGenerator(
                              text:
                                  "Çağırma Tarih : ${widget.customerRequestModel!.comeDate.toString().substring(0, 16)}",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextStyleGenerator(
                    text:
                        "${widget.customerRequestModel!.decriptionByCustomer}",
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Center(
                  child: Container(
                      width: context.getDynmaicWidth(.5),
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: widget.customerRequestModel!.point == null
                            ? SizedBox()
                            : widget.customerRequestModel!.point != null &&
                                    widget.customerRequestModel!.point!
                                            .toInt() ==
                                        0
                                ? TextStyleGenerator(
                                    text: "Müşteri bu işe 0 puan verdi!",
                                    alignment: TextAlign.center,
                                  )
                                : SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: widget
                                            .customerRequestModel!.point!
                                            .toInt(),
                                        itemBuilder: (context, index) {
                                          return Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          );
                                        }),
                                  ),
                      )),
                ),
                Column(
                  children: [
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.customerRequestModel!.artisanId != "" &&
                            widget.customerRequestModel!.artisanId !=
                                widget.userId)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                widget.seeUserProfile();
                              },
                              child: Container(
                                width: context.getDynmaicWidth(.35),
                                padding: EdgeInsets.all(10),
                                color: Colors.lightBlueAccent,
                                child: Center(
                                  child: TextStyleGenerator(
                                    text: "Ustayı gör",
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (widget.customerRequestModel!.status == 4 &&
                            widget.customerRequestModel!.artisanId !=
                                widget.userId)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                widget.changeToEstimateDate!();
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                height: 40,
                                width: context.getDynmaicWidth(.35),
                                color: Colors.greenAccent,
                                child: Center(
                                  child: TextStyleGenerator(
                                    text: "İşi Ertele",
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (widget.customerRequestModel!.status == 0 &&
                            widget.customerRequestModel!.artisanId !=
                                widget.userId &&
                            widget.customerRequestModel!.point == null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                widget.rateArtisan!();
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                height: 40,
                                width: context.getDynmaicWidth(.35),
                                color: Colors.greenAccent,
                                child: Center(
                                  child: TextStyleGenerator(
                                    text: "İşi Puanla",
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (widget.customerRequestModel!.status == 4 &&
                            widget.customerRequestModel!.artisanId ==
                                widget.userId)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                widget.goToCustomer!();
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                height: 40,
                                width: context.getDynmaicWidth(.35),
                                color: Colors.redAccent,
                                child: Center(
                                  child: TextStyleGenerator(
                                    text: "Müşteriye Git",
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.customerRequestModel!.artisanId != "" &&
                        widget.customerRequestModel!.artisanId == widget.userId)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.seeUserProfile();
                          },
                          child: Container(
                            width: context.getDynmaicWidth(.35),
                            padding: EdgeInsets.all(10),
                            color: Colors.lightBlueAccent,
                            child: Center(
                              child: TextStyleGenerator(
                                text: "Müşteriyi gör",
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (widget.customerRequestModel!.status == 5 &&
                        widget.customerRequestModel!.artisanId != "" &&
                        widget.customerRequestModel!.artisanId == widget.userId)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            widget.finsihJob!();
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            height: 40,
                            width: context.getDynmaicWidth(.35),
                            color: Colors.greenAccent,
                            child: Center(
                              child: TextStyleGenerator(
                                text: "İşi Teslim Et",
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
