import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/model/plan.dart';
import 'package:movemedriver/presenter/plan_list_presenter.dart';
import 'package:movemedriver/view/plan/plan_list_item_page.dart';
import 'package:movemedriver/view/plan/plan_list_view.dart';

class PlanListPage extends StatefulWidget {

  @override
  _PlanListPageState createState() => _PlanListPageState();
}

class _PlanListPageState extends BaseState<PlanListPage> implements PlanListView{
  PlanListPresenter _presenter;
  List<Plan> listPlan;
  Plan model;

  @override
  void initState(){
    super.initState();
    model = Plan();
    listPlan = [];
    listPlan.add(model);
    _presenter = PlanListPresenter(this);
    _presenter.listPlan();
  }

  setPlan() {
    var items = <Widget>[];
    listPlan.asMap().forEach((index, Plan model) {
      items.add(
//          new PlanListItem(model: model)
          PlanListItem()
      );
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(
            title: 'Planos',
            callback: () {
              Navigator.pop(context);
            },
          ),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: ListView(
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          children: <Widget>[
//                  new PlanListItem(model: listPlan[0])
            PlanListItem()
          ],
        ),
      ),

    );
  }

  @override
  void onError(String error) {

  }

  @override
  void onListSuccess(List<Plan> listPlan) {

  }
}
