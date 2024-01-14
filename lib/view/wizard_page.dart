import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/wizard/wizard_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class WizardPage extends StatefulWidget {
  final bool isFromInfoPage;

  WizardPage({this.isFromInfoPage = false});

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  WizardBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.initialize());
  }

  Widget getIcon(String icon) {
    // Text(it.icon,
    //     style: TextStyle(
    //         fontFamily: 'MaterialIcons',
    //         fontSize: 25,
    //         color: AppColors.colorBlueLight))

    switch (icon) {
      case 'ballot':
        return Icon(Icons.ballot, color: AppColors.colorBlueLight);
      case 'person_pin':
        return Icon(Icons.person_pin, color: AppColors.colorBlueLight);
      case 'miscellaneous_services':
        return Icon(Icons.miscellaneous_services, color: AppColors.colorBlueLight);
      case 'directions_car':
        return Icon(Icons.directions_car, color: AppColors.colorBlueLight);
      case 'person':
        return Icon(Icons.person, color: AppColors.colorBlueLight);
      case 'bank':
        return Icon(Icons.account_balance, color: AppColors.colorBlueLight);
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<WizardBloc>(context);
    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            appBar: PreferredSize(
                child: AppBarCustom(
                    title: 'Primeiros passos',
                    actions: [
                      if (!widget.isFromInfoPage)
                        IconButton(
                            icon: Icon(Icons.home_filled, color: Colors.white),
                            onPressed: () => eventBus.fire(ChangeStateEvent(AppStateEnum.MAIN)))
                    ],
                    callback: !widget.isFromInfoPage ? null : () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: SingleChildScrollView(
                child: Column(children: [
              SizedBox(height: 10),
              for (var it in bloc.items)
                TransparentButton(
                    callback: () async {
                      await bloc.navigationManager.navigateTo(it.route);
                      await bloc.initialize();
                    },
                    text: it.name,
                    arrow: false,
                    ok: it.status == 'ok',
                    warning: it.status == 'incomplete',
                    pending: it.status == 'pending',
                    iconLeft: getIcon(it.icon))
            ])));
  }
}
