import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/bloc/history/history_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:provider/provider.dart';
import 'history_list_item.dart';

class HistoryListPage extends StatefulWidget {
  @override
  _HistoryListPageState createState() => _HistoryListPageState();
}

class _HistoryListPageState extends BaseState<HistoryListPage> {
  HistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.listHistory());
  }

  String paymentDescription(String payment) {
    switch (payment) {
      case 'money':
        return 'Dinheiro';
      case 'credit':
        return 'Cartão de crédito';
      case 'debit':
        return 'Cartão de débito';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<HistoryBloc>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Histórico'),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: bloc.isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
            : Stack(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: bloc.history.isEmpty
                        ? Center(
                            child: Text('Nenhuma corrida para exibir no momento',
                                style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center))
                        : ListView.builder(
                            padding:
                                EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
                            itemCount: bloc.history.length,
                            itemBuilder: (BuildContext context, int index) {
                              return HistoryListItem(model: bloc.history[index]);
                            }))
              ]));
  }
}
