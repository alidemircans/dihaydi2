import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:uydu/view_model/customer_home_view_model.dart';
import 'package:uydu/view_model/send_request_to_artisan_view_model.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class SendRequestToArtisanPage extends StatefulWidget {
  @override
  _SendRequestToArtisanPageState createState() =>
      _SendRequestToArtisanPageState();
}

class _SendRequestToArtisanPageState extends State<SendRequestToArtisanPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextStyleGenerator(
            text: "Uydu",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBrandChooseModalSheet(),
          _buildModelChooseModalSheet(),
          _buildDescriptionArea(),
          _buildDatePicker(),
          _buildSendNewRequest(context),
        ],
      ),
    );
  }

  Widget _buildSendNewRequest(BuildContext context) {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          if (viewModel.inComingCategoryModel != null &&
              viewModel.selecetedBrand != null &&
              viewModel.selecetedModel != null &&
              viewModel.whenArtisanWillBeComeDate != null) {
            viewModel.sendNewRequest(
              context,
              viewModel.inComingCategoryModel!,
              viewModel.selecetedBrand!,
              viewModel.selecetedModel!,
              viewModel.description,
              viewModel.incomingUser,
              viewModel.whenArtisanWillBeComeDate
            );
          } else {
            SnackBar snackBar = SnackBar(
              content: TextStyleGenerator(
                text: "Boş alanlar var!",
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.redAccent,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          width: context.getDynmaicWidth(.8),
          height: 60,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          color: Colors.lightBlueAccent,
          child: Center(
            child: TextStyleGenerator(
              text: "Gönder",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Consumer<SendRequestToArtisanViewModel> _buildDescriptionArea() {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => Container(
        margin: EdgeInsets.all(10),
        width: context.getDynmaicWidth(1),
        color: Colors.white,
        child: TextField(
          onChanged: (val) {
            viewModel.descriptionSet = val;
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: "Açıklamınızı yazın...",
          ),
          maxLines: 4,
        ),
      ),
    );
  }

  Consumer<SendRequestToArtisanViewModel> _buildBrandChooseModalSheet() {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          if (viewModel.brands.isEmpty) {
            viewModel.onEmptyBrandPressed(context);
          } else {
            viewModel.onChoseABrandPressed(context);
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          width: context.getDynmaicWidth(1),
          height: context.getDynmaicHeight(.1),
          color: Colors.white,
          child: Center(
            child: TextStyleGenerator(
              text: viewModel.selecetedBrand == null
                  ? "Bir kategori seçiniz"
                  : viewModel.selecetedBrand!.name,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Consumer<SendRequestToArtisanViewModel> _buildModelChooseModalSheet() {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          if (viewModel.selecetedBrand == null) {
            viewModel.onNullBrandPressed(context);
          } else {
            viewModel.onChoseAModelPressed(context);
          }
        },
        child: Container(
          margin: EdgeInsets.all(10),
          width: context.getDynmaicWidth(1),
          height: context.getDynmaicHeight(.1),
          color: Colors.white,
          child: Center(
            child: TextStyleGenerator(
              text: viewModel.selecetedModel == null
                  ? "Bir Model seçiniz"
                  : viewModel.selecetedModel!.name,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Consumer<SendRequestToArtisanViewModel>(
      builder: (context, viewModel, child) => GestureDetector(
        onTap: () {
          var now = DateTime.now();
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: now,
              maxTime: DateTime(now.year, now.month, now.day + 5),
              onChanged: (date) {
            viewModel.whenArtisanWillBeComeDateSet = date;
          }, onConfirm: (date) {
            viewModel.whenArtisanWillBeComeDateSet = date;
          }, currentTime: DateTime.now(), locale: LocaleType.tr);
        },
        child: Container(
          margin: EdgeInsets.all(10),
          width: context.getDynmaicWidth(1),
          height: context.getDynmaicHeight(.1),
          color: Colors.white,
          child: Center(
            child: TextStyleGenerator(
              text: viewModel.whenArtisanWillBeComeDate == null
                  ? "Usta ne zaman gelsin?"
                  : viewModel.whenArtisanWillBeComeDate
                      .toString()
                      .substring(0, 11),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
