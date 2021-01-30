import 'dart:io';

import 'package:edexa/constants/color_constant.dart';
import 'package:edexa/constants/string_constant.dart';
import 'package:edexa/models/folder_file_model.dart';
import 'package:edexa/presentations/google_map_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<FolderFileModel> folderFileModelList;
  final bool isListView;
  HomePage({Key key, this.folderFileModelList, this.isListView = true})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> isDeletedIndex = [];
  bool isListView;
  List<FolderFileModel> folderFileModelList;

  @override
  void initState() {
    isListView = widget.isListView;
    folderFileModelList = widget.folderFileModelList ?? initList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: isDeletedIndex.isNotEmpty
                ? InkWell(
                    onTap: () {
                      isDeletedIndex.clear();
                      setState(() {});
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: ColorConstant.white,
                    ),
                  )
                : widget.folderFileModelList == null
                    ? Offstage()
                    : BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
            leadingWidth:
                isDeletedIndex.isNotEmpty || widget.folderFileModelList != null
                    ? 56
                    : 0,
            automaticallyImplyLeading: true,
            title: isDeletedIndex.isNotEmpty
                ? Text('${isDeletedIndex.length} Selected')
                : Text('${StringConstant.welcome} Hardik Kumbhani'),
            actions: getActionAppBarWidget()),
        body: SingleChildScrollView(
          child: Column(
            children: [
              !isListView
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 1.0,
                      ),
                      padding: EdgeInsets.all(8),
                      itemCount: folderFileModelList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            onTapOnGridViewAndListView(index: index);
                          },
                          onLongPress: () {
                            onLongPressOnGirdViewAndListView(index: index);
                          },
                          child: Container(
                            color: isDeletedIndex.contains(index)
                                ? ColorConstant.selectionColor
                                : Colors.grey.shade200,
                            child: GridTile(
                              header: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Column(
                                  children: [
                                    folderFileModelList[index].isFolder
                                        ? getTotalFileAndFolderText(
                                            folderFileModelList[index]
                                                ?.childList)
                                        : Offstage(),
                                    Text(
                                      folderFileModelList[index]
                                          .dateTime
                                          .toString()
                                          .substring(0, 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              footer: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  folderFileModelList[index].name ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              child: folderFileModelList[index].isFolder
                                  ? Icon(Icons.folder)
                                  : Icon(Icons.file_present),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: folderFileModelList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: ListTile(
                            tileColor: Colors.transparent,
                            selected: isDeletedIndex.contains(index),
                            selectedTileColor: ColorConstant.selectionColor,
                            leading: folderFileModelList[index].isFolder
                                ? Icon(Icons.folder)
                                : Icon(Icons.file_present),
                            title: Text(folderFileModelList[index].name ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                folderFileModelList[index].isFolder
                                    ? getTotalFileAndFolderText(
                                        folderFileModelList[index].childList)
                                    : Offstage(),
                                Text(folderFileModelList[index]
                                    .dateTime
                                    .toString()
                                    .substring(0, 16)),
                              ],
                            ),
                            onTap: () {
                              onTapOnGridViewAndListView(index: index);
                            },
                            onLongPress: () {
                              onLongPressOnGirdViewAndListView(index: index);
                            },
                            trailing: Icon(Icons.info),
                          ),
                        );
                      },
                    )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
          Icons.menu,
          Icons.notifications,
          Icons.star_border,
          Icons.person_outline
        ]
                .map(
                  (e) => BottomNavigationBarItem(
                      icon: Icon(e),
                      label: '',
                      backgroundColor: ColorConstant.primaryColor),
                )
                .toList()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 0,
          backgroundColor: ColorConstant.primaryColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Select"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text("File"),
                          onTap: () async {
                            FilePickerResult result = await FilePicker.platform
                                .pickFiles(type: FileType.any);

                            if (result != null) {
                              File file = File(result.files.single.path);
                              folderFileModelList.add(FolderFileModel(
                                  dateTime: DateTime.now(),
                                  isFolder: false,
                                  name: file?.path?.split('/')?.last ??
                                      "Test.env",
                                  childList: []));
                              setState(() {});
                              Navigator.pop(context);
                            } else {
                              // User canceled the picker
                              Navigator.pop(context);
                            }
                          },
                        ),
                        ListTile(
                          title: Text("Create Folder"),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController addFolderName =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text("Add Folder"),
                                    content: TextField(
                                      controller: addFolderName,
                                    ),
                                    actions: [
                                      OutlineButton(
                                        onPressed: () {
                                          folderFileModelList.add(
                                              FolderFileModel(
                                                  dateTime: DateTime.now(),
                                                  isFolder: true,
                                                  name: addFolderName?.text ??
                                                      "Test",
                                                  childList: []));
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Text("Add"),
                                      )
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  );
                });
          },
        ));
  }

  List<Widget> getActionAppBarWidget() {
    if (isDeletedIndex.isNotEmpty)
      return [
        IconButton(icon: Icon(Icons.star_outline), onPressed: () {}),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              for (int index in isDeletedIndex) {
                folderFileModelList.removeAt(index);
              }
              isDeletedIndex.clear();
              setState(() {});
            })
      ];
    else
      return [
        IconButton(
          icon: Icon(isListView ? Icons.grid_on : Icons.list),
          onPressed: () {
            isListView = !isListView;
            setState(() {});
          },
        ),
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(
            icon: Icon(Icons.map_sharp),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GoogleMapPage()));
            }),
        CircleAvatar(
          backgroundImage: NetworkImage(
              'https://cdn.pixabay.com/photo/2014/02/27/16/10/tree-276014__340.jpg'),
        ),
        SizedBox(
          width: 5,
        )
      ];
  }

  Widget getTotalFileAndFolderText(List<FolderFileModel> childList) {
    int files = 0;
    int folders = 0;
    for (FolderFileModel folderFileModel in childList) {
      if (folderFileModel.isFolder) {
        folders++;
      } else {
        files++;
      }
    }
    return files == 0 && folders == 0
        ? Text('Empty Folder')
        : Text('$folders folders $files files');
  }

  void onLongPressOnGirdViewAndListView({int index}) {
    if (isDeletedIndex.contains(index)) {
      isDeletedIndex.remove(index);
    } else {
      isDeletedIndex.add(index);
    }

    setState(() {});
  }

  void onTapOnGridViewAndListView({int index}) {
    if (isDeletedIndex.isNotEmpty) {
      if (isDeletedIndex.contains(index)) {
        isDeletedIndex.remove(index);
      } else {
        isDeletedIndex.add(index);
      }

      setState(() {});
    } else {
      if (folderFileModelList[index].isFolder) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              folderFileModelList: folderFileModelList[index].childList,
              isListView: isListView,
            ),
          ),
        );
      }
    }
  }
}
