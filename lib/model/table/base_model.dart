abstract class BaseModel {
  int isUpload, isDelete;

  BaseModel({this.isUpload = 0, this.isDelete = 0});

  bool isUploaded() {
    return isUpload == 1;
  }

  bool isDeleted() {
    return isDelete == 1;
  }
}
