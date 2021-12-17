import 'package:flutter/material.dart';
import 'package:uydu/helper/routes.dart';
import 'package:uydu/model/category.dart';
import 'package:uydu/widgets/text_generator.dart';
import 'package:uydu/extension/context_extension.dart';

class PayPage extends StatefulWidget {
  List<CategoryModel?> categories;
  PayPage({required this.categories});

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  CategoryModel? selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () {
          if (selected != null) Routes.openCheckOutPage(context, selected);
        },
        child: Container(
          color: selected != null ? Colors.blue : Colors.grey,
          height: 60,
          child: Center(
            child: TextStyleGenerator(
              text: "Devam Et",
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: TextStyleGenerator(
          text: "Hizmetler",
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextStyleGenerator(
              text: "Hangi hizmeti satın alcaksınız?",
              fontSize: 18,
            ),
          ),
          Container(
            width: context.getDynmaicWidth(1),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selected = widget.categories[index]!;
                    });
                  },
                  child: Card(
                    color: selected == null
                        ? Colors.white
                        : selected!.id == widget.categories[index]!.id
                            ? Colors.green
                            : Colors.white,
                    child: ListTile(
                      title: TextStyleGenerator(
                        text: widget.categories[index]!.name,
                        color: selected == null
                            ? Colors.black
                            : selected!.id == widget.categories[index]!.id
                                ? Colors.white
                                : Colors.black,
                        fontSize: 14,
                      ),
                      trailing: TextStyleGenerator(
                        text: widget.categories[index]!.price.toString() + "TL",
                        color: selected == null
                            ? Colors.black
                            : selected!.id == widget.categories[index]!.id
                                ? Colors.white
                                : Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
