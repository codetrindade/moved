import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/extract.dart';
import 'package:movemedriver/core/service/extract_service.dart';
import 'package:movemedriver/locator.dart';

class ExtractBloc extends BaseBloc {
  var extractService = locator.get<ExtractService>();
  Extract model;
  String start = DateTime.now().add(Duration(days: -7)).toString();
  String end = DateTime.now().toString();

  init() {
    start = DateTime.now().add(Duration(days: -7)).toString();
    end = DateTime.now().toString();
  }

  getExtract() async {
    try {
      setLoading(true);
      model = await extractService.getExtract(start, end);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}
