import 'package:dashboard_feirapp/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/dtos/user_login_dto.dart';
import '../../utils/dimensions.dart';
import '../../widgets/Text/custom_text.dart';
import 'widgets/property_table.dart';

class PropertyPage extends StatefulWidget {
  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  UserLoginDto? user;
  String? token;

  //final UserController c = Get.put(UserController(userRepo: Get.find()));

  @override
  void initState() {
    super.initState();
    loadPref();
  }

  loadPref() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    if (sharedUser.getString('user') != null) {
      user = UserLoginDto.fromJson(sharedUser.getString('user') ?? "");
      token = user!.token;
      print(token);

      //Get.find<UserController>().getProductorList(token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ResponsiveWidget.isSmallScreen(context) ? Dimensions.height56 : Dimensions.height5,
                ),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: Dimensions.font24,
                  color: mainWhite,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              ClientsTable(),
            ],
          ),
        ),
      ],
    );
  }
}
