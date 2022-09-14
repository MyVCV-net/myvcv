import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myvcv/models/search/search_model.dart';
import 'package:myvcv/repositories/auth/auth_controller.dart';
import 'package:myvcv/repositories/search/search_controller.dart';
import 'package:myvcv/screens/screens.dart';
import 'package:myvcv/widget/widgets.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = '/SearchPage';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SearchPage(),
    );
  }

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Search",
          searchIcon: false,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 3,
                          // offset:
                          //     const Offset(2, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        SearchController searchController =
                            Get.put(SearchController());
                        searchController.search(value);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            // spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                2, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      // width: 70,
                      // height: 50,
                      child: GestureDetector(
                        onTap: () => showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => const ModalFit(),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(child: Text("Filter")),
                        ),
                      )),
                )
              ],
            ),
            Expanded(
              // height: Get.height / 2,
              child: Obx(
                () => searchController.searchLoading.value
                    ? searchController.allData.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchController.allData.length,
                            itemBuilder: (context, index) {
                              return SearchWidget(
                                  searchModel: searchController.allData[index]);
                            })
                        : Center(
                            child: Text('No Result'),
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ));
  }
}

class SearchWidget extends StatefulWidget {
  final SearchModel searchModel;
  const SearchWidget({
    Key? key,
    required this.searchModel,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: widget.searchModel.isJob
          ? Card(
              child: ListTile(
                onTap: () {
                  // Get.to(JobDesc(selectedJobId: widget.searchModel.id));
                  //CreateNewJobDescPage
                },
                // leading: FlutterLogo(size: 72.0),
                title: Text(widget.searchModel.major),
                subtitle: Text(widget.searchModel.name),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("${widget.searchModel.number} applicants"),
                    Text("Deadline: ${widget.searchModel.deadline}")
                  ],
                ),
                // isThreeLine: true,
              ),
            )
          : Card(
              child: ListTile(
                onTap: () {
                  Get.to(UserProfile(
                      userId: widget.searchModel.id,
                      username: widget.searchModel.name));
                },
                leading: widget.searchModel.imageUrl != ''
                    ? CachedNetworkImage(
                        imageUrl: widget.searchModel.imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/account.png',
                          height: 40,
                          width: 40,
                        ),
                      )
                    : Image.asset(
                        'assets/account.png',
                        height: 40,
                        width: 40,
                      ),
                title: Text(widget.searchModel.name),
                subtitle: widget.searchModel.major == ''
                    ? null
                    : Text(widget.searchModel.major),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GetBuilder<AuthController>(
                      init: Get.put(AuthController()),
                      builder: (controller) => !isLoading
                          ? controller.followingVideo(widget.searchModel.id)
                              ? SizedBox(
                                  height: 25,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).iconTheme.color,
                                    child: Icon(
                                      Icons.done,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    controller.user[0].following
                                        .add(widget.searchModel.id);

                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(controller.user[0].id)
                                        .update(
                                      {
                                        'following': FieldValue.arrayUnion(
                                            [widget.searchModel.id])
                                      },
                                    );
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.searchModel.id)
                                        .update(
                                      {
                                        'follower': FieldValue.arrayUnion(
                                            [controller.user[0].id]),
                                      },
                                    );
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 25,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).iconTheme.color,
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                )
                          : SizedBox(
                              height: 25,
                              width: 25,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class ModalFit extends StatefulWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  _ModalFitState createState() => _ModalFitState();
}

class _ModalFitState extends State<ModalFit> {
  var selcectedId = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text(
                  "Filters",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
                //TODO::Update GroupButton
                // children: [
                //   // GroupButton(
                //   //   isRadio: true,
                //   //   spacing: 10,
                //   //   buttons: const ['Recruiters', 'Job Seeker'],
                //   //   selectedColor: const Color(0xFFD0AB37),
                //   //   borderRadius: BorderRadius.circular(30),
                //   //   onSelected: (i, selected) {
                //   //     setState(() {
                //   //       selcectedId = i;
                //   //     });
                //   //   },
                //   // ),
                // ],
                ),
          ),
          selcectedId == 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Business Model"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Country"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Experience years"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Country"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Academic specialisation"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Age category"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: DropdownButton(
                          // value: _value,
                          items: const [
                            DropdownMenuItem(
                              child: Text("First Item"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Second Item"),
                              value: 2,
                            )
                          ],
                          onChanged: (value) {
                            // setState(() {
                            //   // _value = value;
                            // });
                          },
                          hint: const Text("Gender"),
                          disabledHint: const Text("Disabled"),
                          elevation: 8,
                          // style: TextStyle(
                          //     color: Colors.white, fontSize: 16),
                          icon: const Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.red,
                          iconEnabledColor: const Color(0xFF0A6077),
                          isExpanded: true,
                          // dropdownColor: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, LoginPage.id);
                  },
                  child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A6077),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            // spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                2, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Center(
                          child: Text("Show Results",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )))),
                ),
              ),
            ),
          )
          // ListTile(
          //   title: Text('Delete'),
          //   leading: Icon(Icons.delete),
          //   onTap: () => Navigator.of(context).pop(),
          // )
        ],
      ),
    ));
  }
}
