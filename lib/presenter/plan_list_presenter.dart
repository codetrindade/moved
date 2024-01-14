import 'package:movemedriver/base/base_presenter.dart';
import 'package:movemedriver/service/injector_service.dart';
import 'package:movemedriver/service/plan_service.dart';
import 'package:movemedriver/view/plan/plan_list_view.dart';

class PlanListPresenter extends BasePresenter{

  PlanListView _view;
  PlanService _service;

  PlanListPresenter(this._view) {
    super.view = _view;
    _service = new Injector().planService;
  }

  void listPlan() {
    _service
        .getPlans()
        .then((data) => _view.onListSuccess(data))
        .catchError((error) =>
        super.onError(error, (message) => _view.onError(message)));
  }

}