import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/app/widgets/container_for_transition.dart';
import 'package:property_management/objects/cubit/add_object/add_object_cubit.dart';
import 'package:property_management/objects/pages/create_object_page.dart';
import 'package:property_management/settings/cubit/settings_cubit.dart';
import 'package:property_management/settings/pages/settings_page.dart';

class ListOwnersPage extends StatelessWidget {
  const ListOwnersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        // automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  'Выбор собственника',
                  style: caption,
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BoxIcon(
                iconPath: 'assets/icons/clear.svg',
                iconColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding(context, 44),
                        vertical: 16),
                    child: Column(
                      children: [
                        for (var item in state.owners.keys)
                          ContainerForTransition(
                            title: item,
                            onTap: () {
                              print(item);
                              context.read<SettingsCubit>().selectOwnerName(item);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SettingsPage()),
                              );
                           },
                          ),
                      ],
                    )
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
