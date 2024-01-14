import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/model/document.dart';
import 'package:movemedriver/core/service/document_service.dart';
import 'package:movemedriver/core/service/upload_service.dart';
import 'package:movemedriver/locator.dart';

class DocumentBloc extends BaseBloc {
  var documentService = locator.get<DocumentService>();
  var uploadService = locator.get<UploadService>();

  List<Document> documents = [];

  listDocuments() async {
    try {
      setLoading(true);
      documents = await documentService.listAll();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  chooseImage(ImageSource source, String type) async {
    try {
      File img;
      if (source == ImageSource.gallery) {
        // ? removed exension pdf from allowedExtensions
        FilePickerResult result = await FilePicker.platform.pickFiles(
            allowedExtensions: ['jpg', 'pdf', 'JPG', 'png'],
            type: FileType.image);
        if (result != null && result.count != 0) {
          List<File> files = result.paths.map((path) => File(path)).toList();
          img = files.first;
        }
      } else {
        var pickedFile = await ImagePicker()
            .pickImage(source: source, maxWidth: 1080, maxHeight: 1080);
        img = File(pickedFile.path);
      }

      var doc = documents.firstWhere((element) => element.type == type,
          orElse: () => null);

      if (doc != null && doc.adminStatus != 'incomplete') {
        return;
      }

      switch (type) {
        case 'selfie':
          if (doc == null)
            await uploadService.uploadDocument('selfie', img);
          else
            await uploadService.uploadDocument('selfie', img, id: doc.id);
          break;
        case 'license':
          if (doc == null)
            await uploadService.uploadDocument('license', img);
          else
            await uploadService.uploadDocument('license', img, id: doc.id);
          break;
        case 'criminal':
          if (doc == null)
            await uploadService.uploadDocument('criminal', img);
          else
            await uploadService.uploadDocument('criminal', img, id: doc.id);
          break;
        case 'address':
          if (doc == null)
            await uploadService.uploadDocument('address', img);
          else
            await uploadService.uploadDocument('address', img, id: doc.id);
          break;
      }
      await this.listDocuments();
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  bool verifyOkPhoto(String type) {
    return documents.firstWhere(
            (element) =>
                element.type == type && element.adminStatus != 'incomplete',
            orElse: () => null) !=
        null;
  }

  bool verifyWarningPhoto(String type) {
    return documents.firstWhere(
            (element) =>
                element.type == type && element.adminStatus == 'incomplete',
            orElse: () => null) !=
        null;
  }
}
