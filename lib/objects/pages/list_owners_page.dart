import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class ListOwnersPage extends StatefulWidget {
  final String title;
  final Function onTap;
  const ListOwnersPage({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  State<ListOwnersPage> createState() => _ListOwnersPageState();
}

class _ListOwnersPageState extends State<ListOwnersPage> {

  @override
  void initState() {
    isOneOwner();
    super.initState();
  }

  void isOneOwner() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (context.read<AppBloc>().state.owners.keys.toList().length == 1) {
        String item = context.read<AppBloc>().state.owners.keys.toList().first;
        Navigator.pop(context);

        if (widget.title == 'Новый объект') {
          context.read<AddObjectCubit>().getItems(
              context.read<AppBloc>().state.owners[item]['object_characteristics']);
          context.read<AddObjectCubit>().changeItemValue(
              3, item, '');

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateObjectPage()),
          );
        } else {
          context.read<SettingsCubit>().selectOwnerName(item);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SettingsPage()
            ),
          );
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: widget.title != 'Настройки',
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.title == 'Настройки')
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
                  widget.title,
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
                    child: state.owners.keys.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_white.svg',
                                color: Color(0xffE9ECEE),
                                height: 80,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              Text(
                                'У Вас пока нет собственников',
                                textAlign: TextAlign.center,
                                style: body.copyWith(
                                  color: Color(0xffC7C9CC),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              for (var item in sortList(state.owners.keys.toList()))
                                ContainerForTransition(
                                  title: item,
                                  icon: widget.title == 'Новый объект'
                                      ? null
                                      : Icons.arrow_forward_ios,
                                  onTap: () {
                                    if (widget.title == 'Новый объект') {
                                      context.read<AddObjectCubit>().getItems(
                                          state.owners[item]['object_characteristics']);
                                      context.read<AddObjectCubit>().changeItemValue(
                                          3, item, '');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CreateObjectPage(
                                              onBack: () {
                                                Navigator.pop(context);
                                              },
                                            )),
                                      );
                                    } else {
                                      context.read<SettingsCubit>().selectOwnerName(item);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SettingsPage()),
                                      );
                                    }
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
