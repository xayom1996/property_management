import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/account/pages/account_page.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/objects/pages/edit_object_page.dart';
import 'package:property_management/settings/cubit/settings_cubit.dart';
import 'package:property_management/settings/pages/characteristic_items_page.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            leading: null,
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxIcon(
                  iconPath: 'assets/icons/back.svg',
                  iconColor: Colors.black,
                  backgroundColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Настройки',
                      style: body,
                    ),
                    Text(
                      settingsState.ownerName,
                      style: caption,
                    ),
                  ],
                ),
                Spacer(),
                SizedBox(
                  height: 44,
                  width: 44,
                ),
              ],
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                  child: BlocConsumer<AppBloc, AppState>(
                    listener: (context, state) {

                    },
                    buildWhen: (previousState, state) {
                      return previousState.owners != state.owners
                          || previousState.status != state.status;
                    },
                    builder: (context, state) {
                      // print(state.owners);
                      return Column(
                        children: [
                          ContainerForTransition(
                            title: 'Характеристики Объекта',
                            onTap: () {
                              context.read<SettingsCubit>().selectCharacteristicsName('object_characteristics');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                                  title: 'Характеристики Объекта',
                                  items: state.owners[settingsState.ownerName]['object_characteristics'],
                                )),
                              );
                            },
                          ),
                          ContainerForTransition(
                            title: 'Характеристики Арендатора',
                            onTap: () {
                              context.read<SettingsCubit>().selectCharacteristicsName('tenant_characteristics');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                                  title: 'Характеристики Арендатора',
                                  items: state.owners[settingsState.ownerName]['tenant_characteristics'],
                                )),
                              );
                            },
                          ),
                          ContainerForTransition(
                            title: 'Эксплуатация Объекта',
                            onTap: () {
                              context.read<SettingsCubit>().selectCharacteristicsName('expense_characteristics');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                                  title: 'Эксплуатация Объекта',
                                  items: state.owners[settingsState.ownerName]['expense_characteristics'],
                                )),
                              );
                            },
                          ),
                          ContainerForTransition(
                            title: 'Эксплуатационные статьи',
                            onTap: () {
                              context.read<SettingsCubit>().selectCharacteristicsName('expense_article_characteristics');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CharacteristicItemsPage(
                                  title: 'Эксплуатационные статьи',
                                  items: state.owners[settingsState.ownerName]['expense_article_characteristics'],
                                )),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

}