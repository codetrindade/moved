import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/bloc/vehicle/vehicle_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/vehicle/vehicle_create_information_page.dart';
import 'package:movemedriver/view/vehicle/vehicle_list_item.dart';
import 'package:provider/provider.dart';

class VehicleListPage extends StatefulWidget {
  @override
  _VehicleListPageState createState() => _VehicleListPageState();
}

class _VehicleListPageState extends BaseState<VehicleListPage> {
  VehicleBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.getListVehicle());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<VehicleBloc>(context);
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(
            title: 'Veículos',
            callback: () {
              Navigator.pop(context);
            },
          ),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: bloc.isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
          : RefreshIndicator(
              onRefresh: () async => await bloc.getListVehicle(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: bloc.listVehicle.isEmpty
                          ? Center(
                              child: Text('Nenhum veículo para exibir no momento',
                                  style: AppTextStyle.textGreySmallBold,
                                  textAlign: TextAlign.center))
                          : ListView(
                              padding: EdgeInsets.all(0),
                              scrollDirection: Axis.vertical,
                              children: List.generate(
                                  bloc.listVehicle.length,
                                  (index) => VehicleListItem(
                                      model: bloc.listVehicle[index],
                                      callback: () async {
                                        if (bloc.listVehicle[index].adminStatus == 'pending') {
                                          bloc.dialogService.showDialog('Atenção',
                                              'Aguarde, nossa equipe está analisando este veículo');
                                          return;
                                        } else if (bloc.listVehicle[index].adminStatus ==
                                            'incomplete')
                                          await bloc
                                              .editIncompleteVehicle(bloc.listVehicle[index].id);
                                        else if (bloc.listVehicle[index].adminStatus == 'approved')
                                          await bloc.getDetails(bloc.listVehicle[index]);
                                      }))),
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => VehicleCreateInformationPage())),
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppColors.colorGreenLight, borderRadius: BorderRadius.circular(60)),
                  child: Center(
                      child: Text('Adicionar novo',
                          style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center))),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppColors.colorGreenLight, borderRadius: BorderRadius.circular(60)),
                  child: Center(
                      child: Text('Ler código QR',
                          style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center))),
            ),
          ],
        ),
      ),
    );
  }
}
