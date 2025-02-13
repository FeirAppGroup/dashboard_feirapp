import 'package:dashboard_feirapp/controllers/model_controller/property_controller.dart';
import 'package:dashboard_feirapp/models/model/property_model.dart';
import 'package:dashboard_feirapp/pages/propertys/widgets/property_form.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/style.dart';
import '../../../models/dtos/user_login_dto.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/Button/icon_button_widget.dart';
import '../../../widgets/Text/custom_text.dart';

/// Example without a datasource
class PropertyTable extends StatefulWidget {
  @override
  State<PropertyTable> createState() => _PropertyTableState();
}

class _PropertyTableState extends State<PropertyTable> {
  var propertyController = Get.find<PropertyController>();

  List<PropertyModel> propertys = [];

  UserLoginDto? user;
  String? token;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadPref();
  }

  initPropertys() async {
    setState(() {
      isLoading = true;
    });

    await propertyController.getPropertyList(token!);
    propertys = propertyController.propertyList;

    setState(() {
      isLoading = false;
    });
  }

  loadPref() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    if (sharedUser.getString('user') != null) {
      user = UserLoginDto.fromJson(sharedUser.getString('user') ?? "");
      token = user!.token;

      initPropertys();
    }
  }

  DataTable _createDataTable(BuildContext context) {
    return DataTable(columns: _createColumns(), rows: _createRows(context));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn2(
        label: CustomText(
          text: 'Nome',
          color: textWhite,
          size: Dimensions.font12,
        ),
        size: ColumnSize.L,
      ),
      DataColumn(
        label: CustomText(
          text: 'Endereço',
          color: textWhite,
          size: Dimensions.font10,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Editar',
          color: textWhite,
          size: Dimensions.font12,
        ),
      ),
      DataColumn(
        label: CustomText(
          text: 'Apagar',
          color: textWhite,
          size: Dimensions.font12,
        ),
      ),
    ];
  }

  List<DataRow> _createRows(
    BuildContext context,
  ) {
    return propertys
        .map(
          (propertys) => DataRow(
            cells: [
              DataCell(
                CustomText(
                  text: propertys.nome,
                  color: textWhite,
                ),
              ),
              DataCell(
                CustomText(
                  text: propertys.endereco,
                  color: textWhite,
                ),
              ),
              DataCell(
                IconButtonWidget(
                  width: Dimensions.width40,
                  height: Dimensions.height40,
                  backgroundColor: textLiteblue,
                  iconColor: mainBlack,
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyForm(id: propertys.id),
                      ),
                    );
                  },
                ),
              ),
              DataCell(
                IconButtonWidget(
                  width: Dimensions.width40,
                  height: Dimensions.height40,
                  backgroundColor: tertiaryRed,
                  iconColor: mainBlack,
                  icon: Icons.delete,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.red,
                          child: CustomText(
                            text: "Remoção completa",
                            color: textWhite,
                            size: Dimensions.font12,
                          ),
                        );
                      },
                    );

                    _deleteProperty(propertys.id!);
                  },
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  Future<void> _deleteProperty(int idProperty) async {
    await propertyController.deleteProperty(idProperty, token!);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true || propertys.isEmpty
        ? Center(
            child: SpinKitCircle(
              itemBuilder: (BuildContext context, int index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                );
              },
            ),
          )
        : Container(
            padding: EdgeInsets.all(Dimensions.height16),
            margin: EdgeInsets.only(bottom: Dimensions.height30),
            decoration: BoxDecoration(
              color: mainBlack,
              borderRadius: BorderRadius.circular(Dimensions.radius8),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, Dimensions.height5),
                  color: lightGrey.withOpacity(.1),
                  blurRadius: Dimensions.radius12,
                ),
              ],
              border: Border.all(
                color: mainWhite,
                width: .5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createDataTable(context),
              ],
            ),
          );
  }
}
