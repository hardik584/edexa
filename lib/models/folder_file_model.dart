class FolderFileModel {
  String name;
  DateTime dateTime;
  bool isFolder;
  List<FolderFileModel> childList;
  FolderFileModel({
    this.name,
    this.dateTime,
    this.isFolder = false,
    this.childList,
  });
}
