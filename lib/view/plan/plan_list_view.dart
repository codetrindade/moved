import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/model/plan.dart';

abstract class PlanListView extends BaseView {

  void onListSuccess(List<Plan> listPlan);

  void onError(String error);

}