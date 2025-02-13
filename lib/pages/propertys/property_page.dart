import 'package:dashboard_feirapp/constants/style.dart';
import 'package:dashboard_feirapp/controllers/model_controller/property_controller.dart';
import 'package:dashboard_feirapp/controllers/model_controller/user_controller.dart';
import 'package:dashboard_feirapp/data/api/api_client.dart';
import 'package:dashboard_feirapp/pages/propertys/widgets/property_form.dart';
import 'package:dashboard_feirapp/widgets/Cards/card_bottom_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/controllers.dart';
import '../../helpers/responsiveness.dart';
import '../../models/dtos/user_login_dto.dart';
import '../../utils/dimensions.dart';
import '../../widgets/Button/button_widget.dart';
import '../../widgets/Button/icon_button_widget.dart';
import '../../widgets/Cards/card_title_table.dart';
import '../../widgets/Text/custom_text.dart';
import 'widgets/property_table.dart';

class PropertyPage extends StatefulWidget {
  @override
  State<PropertyPage> createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {
  UserLoginDto? user;
  String? token;

  //final PropertyController p = Get.put(PropertyController(propertyRepo: Get.find()));
  //final UserController u = Get.put(UserController(userRepo: Get.find()));
  var userController = Get.find<UserController>();

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

      Get.find<PropertyController>().getPropertyList(token!);
      Get.find<UserController>().getProductorList(token!);
    }
  }

  _nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PropertyForm(id: null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                Container(
                  height: Dimensions.height50,
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
          Padding(
            padding: EdgeInsets.only(top: Dimensions.height20, bottom: Dimensions.height20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CardTitleTable(
                  title: "Tabela de Propriedades",
                  isActive: true,
                  button: ButtonWidget(
                    onTap: () {
                      _nextPage();
                    },
                    text: 'Adicionar Propriedades',
                    backgroundColor: active,
                    height: Dimensions.height40,
                    width: Dimensions.width150,
                    textColor: textWhite,
                  ),
                  iconButton: IconButtonWidget(
                    backgroundColor: starTableColor,
                    height: Dimensions.height40,
                    width: Dimensions.width64,
                    onTap: () {
                      // Just insert this code to button to refresh page.​
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PropertyPage()), // this mainpage is your page to refresh.
                        (Route<dynamic> route) => false,
                      );
                    },
                    icon: Icons.replay_outlined,
                    iconColor: mainWhite,
                  ),
                ),
              ],
            ),
          ),
          PropertyTable(),
        ],
      ),
    );
  }
}
