import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/objects/cubit/add_object/add_object_cubit.dart';
import 'package:property_management/objects/pages/change_field_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/objects/pages/item_page.dart';

class CreateObjectPage extends StatelessWidget {
  CreateObjectPage({Key? key}) : super(key: key);

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
            Text(
              'Новый объект',
              style: body,
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
      body: BlocConsumer<AddObjectCubit, AddObjectState>(
        listener: (context, state) {
          if (state.status == StateStatus.success) {
            var user = context.read<AppBloc>().state.user;
            var owners = context.read<AppBloc>().state.owners;
            context.read<ObjectsBloc>().add(ObjectsGetEvent(user: user, owners: owners));

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  SuccessfullPage(
                    information: Text(
                      'Объект успешно добавлен',
                      textAlign: TextAlign.center,
                      style: body.copyWith(
                          color: Color(0xff151515)
                      ),
                    ),
                  )),
            );
          }
        },
        builder: (context, state) {
          return state.status == StateStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 44), vertical: 16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var item in state.addItems)
                              BoxInputField(
                                controller: TextEditingController(text: item.getFullValue()),
                                placeholder: item.placeholder ?? '',
                                title: item.title,
                                enabled: false,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ItemPage(
                                      item: item,
                                      onChange: (int id, String value) {
                                        print(id);
                                        print(value);
                                        context.read<AddObjectCubit>().changeItemValue(id, value);
                                      },
                                    )),
                                  );
                                },
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                  color: Color(0xff5589F1),
                                ),
                                // isError: isError,
                              ),
                            SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == StateStatus.valid)
                      Positioned(
                        bottom: 24,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context, 0.25.sw), vertical: 16),
                          child: SizedBox(
                            width: 1.sw - horizontalPadding(context, 0.25.sw) * 2,
                            child: BoxButton(
                              title: 'Создать',
                              onTap: (){
                                context.read<AddObjectCubit>().addObject();
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
        },
      ),
    );
  }

}