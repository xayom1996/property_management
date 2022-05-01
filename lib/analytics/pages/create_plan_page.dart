import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:property_management/account/pages/successfull_page.dart';
import 'package:property_management/analytics/cubit/add_plan_cubit.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/cubit/adding/adding_state.dart';
import 'package:property_management/app/widgets/custom_alert_dialog.dart';
import 'package:property_management/objects/bloc/objects_bloc.dart';
import 'package:property_management/settings/pages/change_field_page.dart';
import 'package:property_management/app/theme/box_ui.dart';
import 'package:property_management/app/theme/colors.dart';
import 'package:property_management/app/theme/styles.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/app/widgets/box_icon.dart';
import 'package:property_management/objects/pages/item_page.dart';

class CreatePlanPage extends StatefulWidget {
  final String docId;
  CreatePlanPage({Key? key, required this.docId}) : super(key: key);

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  int currentId = -1;
  TextEditingController currentController = TextEditingController();
  FocusNode currentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Новый план',
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
      body: BlocConsumer<AddPlanCubit, AddingState>(
        listener: (context, state) {
          if (state.status == StateStatus.success) {
            context.read<ObjectsBloc>().add(ObjectsUpdateEvent());

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  SuccessfullPage(
                    information: Text(
                      'Новый план успешно добавлен',
                      textAlign: TextAlign.center,
                      style: body.copyWith(
                          color: Color(0xff151515)
                      ),
                    ),
                  )),
            );
          }

          if (state.status == StateStatus.error) {
            showDialog(
                context: context,
                builder: (context) => CustomAlertDialog(
                  title: state.errorMessage,
                  firstButtonTitle: 'Ок',
                  secondButtonTitle: null,
                )
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
                                controller: currentId == item.id
                                    ? currentController
                                    : TextEditingController(text: item.getFullValue()),
                                placeholder: item.placeholder ?? '',
                                title: item.title,
                                enabled: item.title != 'Система налогообложения'
                                    && item.title != 'Расходы на управление (% от реального дохода)'
                                    && item.type != 'Дата',
                                disableSpace: item.type == 'Число',
                                keyboardType: item.title == 'Номер телефона'
                                    ? TextInputType.phone
                                    : item.type == 'Число'
                                    ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                                    : null,
                                onTap: () {
                                  if (item.isDate()) {
                                    FocusScope.of(context).unfocus();
                                    if (currentId != -1) {
                                      context.read<AddPlanCubit>().changeItemValue(currentId, currentController.text);
                                    }

                                    setState(() {
                                      currentController.text = item.value ?? '';
                                      currentController.selection = TextSelection.fromPosition(TextPosition(offset: currentController.text.length));
                                      currentId = item.id;
                                    });

                                    DateTime maxTime = DateTime(2025, 12, 31);
                                    DateTime minTime = DateTime(2000, 1, 1);
                                    DatePicker.showPicker(context,
                                        showTitleActions: true,
                                        onConfirm: (date) {
                                          if (currentId != -1) {
                                            currentController.text =
                                                DateFormat('dd.MM.yyyy')
                                                    .format(date);
                                            context.read<AddPlanCubit>().changeItemValue(currentId, currentController.text);
                                          }
                                          setState(() {
                                            currentId = -1;
                                          });
                                        },
                                        pickerModel: CustomPicker(
                                          currentTime: currentController.text == ''
                                              ? DateTime.now()
                                              : DateFormat('dd.MM.yyyy').parse(currentController.text),
                                          locale: LocaleType.ru,
                                          maxTime: maxTime,
                                          minTime: minTime,
                                        ),
                                        locale: LocaleType.ru
                                    );
                                  }
                                },
                                onSubmit: (String value) {
                                  if (currentId != -1) {
                                    context.read<AddPlanCubit>().changeItemValue(currentId, currentController.text);
                                  }
                                  setState(() {
                                    currentId = -1;
                                  });
                                },
                                onTapTextField: () {
                                  if (item.title != 'Система налогообложения' && item.title != 'Расходы на управление (% от реального дохода)') {
                                    setState(() {
                                      if (currentId != -1) {
                                        context.read<AddPlanCubit>().changeItemValue(currentId, currentController.text);
                                      }
                                      currentController.text = item.value ?? '';
                                      currentController.selection = TextSelection.fromPosition(TextPosition(offset: currentController.text.length));
                                      currentId = item.id;
                                    });
                                  }
                                },
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
                                if (currentId != -1) {
                                  context.read<AddPlanCubit>().changeItemValue(currentId, currentController.text);
                                }
                                context.read<AddPlanCubit>().add(widget.docId);
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