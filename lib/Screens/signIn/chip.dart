import 'package:crave/utils/color_constant.dart';
import 'package:crave/utils/images.dart';
import 'package:crave/widgets/custom_text.dart';
import 'package:crave/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WrapWidgetDemo extends StatefulWidget {
  //
  final String title = 'Wrap Widget & Chips';

  @override
  State<StatefulWidget> createState() => _WrapWidgetDemoState();
}

class _WrapWidgetDemoState extends State<WrapWidgetDemo> {
  //

  late GlobalKey<ScaffoldState> _key;
  late List<Company> _companies;
  late List<String> _filters;

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<ScaffoldState>();
    _filters = <String>[];
    _companies = <Company>[
      Company('Casual Dating', false, casualDating1),
      Company('No String Attached', false, nostring),
      Company('In Person', false, inperson),
      Company('Sexting', false, sexting),
      Company('Kinky', false, kinky),
      Company('Vanilla', false, vanilla),
      Company('Submissive', false, submissive),
      Company('Dominance', false, dominance1),
      Company('Dress Up', false, dressup1),
      Company('Blindfolding', false, blindfolding1),
      Company('Bondage', false, bondage1),
      Company('Roleplay', false, roleplay1),
      Company('Feet Stuff', false, feetstuf1),
      Company('Golden Showers', false, shower1),
      Company('Dirty Talk', false, dirtytalk),
      Company('Cuddling', false, cuddling1)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Wrap(
            children: companyWidgets.toList(),
          ),
          Text('Selected: ${_filters.join(', ')}'),
        ],
      ),
    );
  }

  Iterable<Widget> get companyWidgets sync* {
    for (Company company in _companies) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
          showCheckmark: false,
          // avatar: CircleAvatar(
          //   child: Text(company.name[0].toUpperCase()),
          // ),
          backgroundColor:
              company.status == false ? Colors.white : AppColors.redcolor,
          label: text(context, company.name, 12.sp,
              color: company.status == false ? Colors.black : AppColors.white,
              boldText: FontWeight.w400,
              fontFamily: "Poppins-Regular"),
          selected: _filters.contains(company.name),
          selectedColor:
              company.status == false ? Colors.white : AppColors.redcolor,
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                if (_filters.length < 3) {
                  _filters.add(company.name);
                  company.status = true;
                } else {
                  ToastUtils.showCustomToast(
                      context, "limit exceeded", Colors.green);
                }
              } else {
                company.status = false;
                _filters.removeWhere((String name) {
                  return name == company.name;
                });
              }

              if (_filters.length < 3) {
              } else {
                ToastUtils.showCustomToast(
                    context, "limit acheived", Colors.green);
              }
            });
          },
        ),
      );
    }
  }
}

class Company {
  Company(this.name, this.status, this.iconname);
  final String name;
  bool status;
  final String iconname;
}
