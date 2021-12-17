import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uydu/helper/color_helper.dart';
import 'package:uydu/model/user.dart';
import 'package:uydu/view_model/customer_home_view_model.dart';
import 'package:uydu/view_model/translate_view_model.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uydu/widgets/translataion_widget.dart';

class CustomerHomePage extends StatefulWidget {
  User? user;

  CustomerHomePage({required this.user});
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  CameraPosition? _initalCameraPosition;
  GoogleMapController? _controller;

  initState() {
    _initalCameraPosition = CameraPosition(
      target: LatLng(
        double.parse(widget.user!.lat.toString()),
        double.parse(
          widget.user!.long.toString(),
        ),
      ),
      zoom: 15,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomerHomeViewModel customerHomeViewModel =
        Provider.of<CustomerHomeViewModel>(context);
    TranslateViewModel translateController = Get.find();

    return Consumer<CustomerHomeViewModel>(
      builder: (context, viewModel, child) =>
          translateController.translateState == TranslateState.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorHelper.accentColor),
                  ),
                )
              : translateController.translateState == TranslateState.Error
                  ? Center(
                      child: TextStyleGenerator(
                      text: "Error!",
                    ))
                  : Scaffold(
                      drawer: _buildDrawerMenu(),
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.lightBlue,
                        title: TextStyleGenerator(
                          text: "Uydu",
                          color: Colors.white,
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              viewModel.openProfilePage(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.person_outline,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              viewModel.openAllChatsPage(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.message,
                              ),
                            ),
                          ),
                        ],
                      ),
                      body: SafeArea(
                        child: _buildBody(context),
                      ),
                    ),
    );
  }

  Consumer<CustomerHomeViewModel> _buildDrawerMenu() {
    return Consumer<CustomerHomeViewModel>(
      builder: (context, viewModel, child) => Drawer(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.lightBlueAccent,
                    width: context.getDynmaicWidth(1),
                    height: context.getDynmaicHeight(.1),
                  ),
                  GestureDetector(
                    onTap: () {
                      //viewModel.openAllRequestsPage(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.call),
                      title: TextStyleGenerator(
                        text: "0850 *** ** ** ",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // viewModel.openAllRequestsPage(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: TextStyleGenerator(
                        text: "Uydu Hakkında",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //  viewModel.openAllRequestsPage(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: TextStyleGenerator(
                        text: "Uygulamayı Değerlendir",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  viewModel.signOut(context);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                  ),
                  title: TextStyleGenerator(
                    text: "Çıkış",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<CustomerHomeViewModel>(
      builder: (context, viewModel, child) => RefreshIndicator(
        backgroundColor: Colors.pink,
        color: Colors.white,
        onRefresh: () async {
          await viewModel.initPage();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSlider(context),
              _buildCategoryStaggeredGridView()
            ],
          ),
        ),
      ),
    );
  }

  Consumer<CustomerHomeViewModel> _buildCategoryStaggeredGridView() {
    return Consumer<CustomerHomeViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          margin: EdgeInsets.only(top: 10, left: 3, right: 3),
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            itemCount: viewModel.categories.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: GestureDetector(
                  onTap: () {
                    viewModel.openListArtisanByCategoryPage(
                      context,
                      viewModel.categories[index]!.id,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(2),
                    width: context.getDynmaicWidth(.4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                    ),
                    height: context.getDynmaicHeight(.05),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextStyleGenerator(
                            text: viewModel.categories[index]!.name,
                            color: Colors.black,
                            fontSize: 14,
                            alignment: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSlider(context) {
    return Consumer<CustomerHomeViewModel>(
      builder: (context, viewModel, child) => Container(
        width: context.getDynmaicWidth(1),
        height: context.getDynmaicHeight(.3),
        child: GoogleMap(
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _initalCameraPosition!,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          markers: viewModel.markers,
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
