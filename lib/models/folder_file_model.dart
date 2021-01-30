class FolderFileModel {
  String name;
  DateTime dateTime;
  bool isFolder;
  List<FolderFileModel> childList;
  bool isSelected;
  FolderFileModel(
      {this.name,
      this.dateTime,
      this.isFolder = false,
      this.childList,
      this.isSelected = false});

  @override
  String toString() {
    return name.toString();
  }
}

List<FolderFileModel> initList = [
  FolderFileModel(
    dateTime: DateTime.now().subtract(Duration(days: 15)),
    name: 'Service',
    isFolder: true,
    childList: [
      FolderFileModel(
        dateTime: DateTime.now().subtract(Duration(days: 14)),
        name: 'Service',
      ),
      FolderFileModel(
          dateTime: DateTime.now().subtract(Duration(days: 13)),
          name: 'Service',
          childList: [],
          isFolder: true),
    ],
  ),
  FolderFileModel(
    dateTime: DateTime.now().subtract(Duration(days: 12)),
    name: 'Pet',
    isFolder: true,
    childList: [
      FolderFileModel(
        dateTime: DateTime.now().subtract(Duration(days: 11)),
        name: 'a.txt',
      ),
      FolderFileModel(
        dateTime: DateTime.now().subtract(Duration(days: 10)),
        name: 'b.txt',
      ),
      FolderFileModel(
        dateTime: DateTime.now().subtract(Duration(days: 9)),
        name: 'c.txt',
      ),
      FolderFileModel(
        dateTime: DateTime.now().subtract(Duration(days: 8)),
        name: 'd.txt',
      ),
    ],
  ),
  FolderFileModel(
    dateTime: DateTime.now().subtract(Duration(days: 7)),
    name: 'Independent.mp3',
    isFolder: false,
  ),
  FolderFileModel(
    dateTime: DateTime.now().subtract(Duration(days: 6)),
    name: 'disco.mp3',
    isFolder: false,
  ),
  FolderFileModel(
    dateTime: DateTime.now().subtract(Duration(days: 5)),
    name: 'sample.doc',
    isFolder: false,
  ),
];
