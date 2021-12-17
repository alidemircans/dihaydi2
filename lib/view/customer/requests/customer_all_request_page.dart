import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/view_model/customer_all_request_view_model.dart';
import 'package:uydu/view_model/send_request_to_artisan_view_model.dart';
import 'package:uydu/widgets/request_card.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class CustomerAllRequestPage extends StatelessWidget {
  const CustomerAllRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerAllRequestViewModel>(
      builder: (context, viewModel, child) => RefreshIndicator(
        backgroundColor: Colors.pink,
        color: Colors.white,
        onRefresh: () async {
          await viewModel.initPage();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextStyleGenerator(
              text: "UYDU",
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: viewModel.allRequestState == AllRequestState.Loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(ColorHelper.accentColor),
                    ),
                  )
                : _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<CustomerAllRequestViewModel>(
      builder: (context, viewModel, child) => viewModel.requests.length == 0
          ? Center(
              child: TextStyleGenerator(
                text: "Henüz bir işleminiz yok.",
                color: Colors.white,
              ),
            )
          : ListView.builder(
              itemCount: viewModel.requests.length,
              itemBuilder: (context, index) {
                return RequestCard(
                  customerRequestModel: viewModel.requests[index],
                  userId: viewModel.user!.userId,
                  seeUserProfile: () {
                    viewModel.openOtherProfilePage(
                      context,
                      viewModel.user!.userId ==
                              viewModel.requests[index]!.artisanId
                          ? viewModel.requests[index]!.customerId
                          : viewModel.requests[index]!.artisanId,
                    );
                  },
                  changeToEstimateDate: () async {
                    bool isOk =
                        await Provider.of<SendRequestToArtisanViewModel>(
                                context,
                                listen: false)
                            .changeToEstimateDate(
                                context, viewModel.requests[index]!.requestId);
                    if (isOk) {
                      viewModel.getAllRequest();
                    }
                  },
                  rateArtisan: () async {
                    bool isOk =
                        await Provider.of<SendRequestToArtisanViewModel>(
                                context,
                                listen: false)
                            .rateArtisan(
                                context, viewModel.requests[index]!.requestId);
                    if (isOk) {
                      viewModel.getAllRequest();
                    }
                  },
                );
              },
            ),
    );
  }
}
