import 'package:flutter/material.dart';
import 'package:land_registration/LandRegisterModel.dart';
import 'package:land_registration/constant/constants.dart';
import 'package:land_registration/home_page.dart';
import 'package:land_registration/widget/menu_item_tile.dart';
import 'package:provider/provider.dart';

class LandInspector extends StatefulWidget {
  const LandInspector({Key? key}) : super(key: key);

  @override
  _LandInspectorState createState() => _LandInspectorState();
}

class _LandInspectorState extends State<LandInspector> {
  var model;
  final colors = <Color>[Colors.indigo, Colors.blue, Colors.orange, Colors.red];
  List<List<dynamic>> userData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screen = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<Menu> menuItems = [
    Menu(title: 'Dashboard', icon: Icons.dashboard),
    Menu(title: 'Verify User', icon: Icons.verified_user),
    Menu(title: 'Verify Land', icon: Icons.web),
    Menu(title: 'Logout', icon: Icons.logout),
  ];
  // @override
  // void initState() {
  //   super.initState();
  //   _animationController =
  //       AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  //   _animation =
  //       Tween<double>(begin: 250, end: 70).animate(_animationController);
  // }

  @override
  Widget build(BuildContext context) {
    model = Provider.of<LandRegisterModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("LandInspector Dashboard"),
        centerTitle: true,
        backgroundColor: Color(0xFF272D34),
        leading: isDesktop
            ? Container()
            : GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.black,
                  ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
      ),
      drawer: drawer2(),
      drawerScrimColor: Colors.transparent,
      body: Row(
        children: [
          isDesktop ? drawer2() : Container(),
          if (screen == 0)
            Expanded(
                child: ListView(
              children: [
                Row(
                  children: [
                    _container(0),
                    _container(1),
                    _container(2),
                  ],
                ),
              ],
            ))
          else if (screen == 1)
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25),
                child: userList(),
              ),
            )
          else if (screen == 2)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }

  Widget drawer() {
    return Container(
      width: 250,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blueGrey,
              Colors.grey,
            ],
          ),
          //color: Color(0xFFBb3b3cc),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all()),
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text('Welcome'),
          onTap: () {
            setState(() {
              screen = 0;
            });
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user),
          title: Text('VerifyUser'),
          onTap: () {
            setState(() {
              screen = 2;
            });
            getUserList();
          },
        ),
        ListTile(
          leading: Icon(Icons.verified_user),
          title: Text('VerifyLand'),
          onTap: () async {},
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home_page()));
          },
        ),
      ]),
    );
  }

  Future<void> getUserList() async {
    List<dynamic> userList = await model.allUsers();

    List<List<dynamic>> allInfo = [];
    List<dynamic> temp;
    for (int i = 0; i < userList.length; i++) {
      print(userList[i].toString());
      temp = await model.userInfo(userList[i].toString());
      allInfo.add(temp);
    }
    setState(() {
      userData = allInfo;
      screen = 1;
    });
    //return allInfo;
  }

  Widget userList() {
    return ListView.builder(
        itemCount: userData == null ? 1 : userData.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                const Divider(
                  height: 15,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    const Expanded(
                        child: Center(
                          child: Text('Address',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        flex: 5),
                    const Expanded(
                      child: Center(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 3,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Adhar',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Pan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Document',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    const Expanded(
                      child: Center(
                        child: Text('Verify',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    )
                  ],
                ),
                const Divider(
                  height: 15,
                )
              ],
            );
          }
          index -= 1;
          List<dynamic> data = userData[index];
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text((index + 1).toString()),
                  flex: 1,
                ),
                Expanded(
                    child: Center(
                      child: Text(data[0].toString()),
                    ),
                    flex: 5),
                Expanded(
                    child: Center(
                      child: Text(data[1].toString()),
                    ),
                    flex: 3),
                Expanded(
                    child: Center(child: Text(data[4].toString())), flex: 2),
                Expanded(
                    child: Center(child: Text(data[5].toString())), flex: 2),
                Expanded(
                    child: Center(
                        child: Text(
                      data[6].toString(),
                    )),
                    flex: 2),
                Expanded(
                    child: Center(
                      child: data[8]
                          ? Text('Verified')
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  screen = 2;
                                });
                                await model.verifyUser(data[0].toString());
                                getUserList();
                              },
                              child: Text('Verify')),
                    ),
                    flex: 2),
              ],
            ),
          );
        });
  }

  Widget _container(int index) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Color(0xFFE7E7E7),
        child: Card(
          color: Color(0xFFE7E7E7),
          child: Container(
            color: colors[index],
            width: 250,
            height: 140,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '0',
                        style: TextStyle(fontSize: 24),
                      )),
                    ],
                  ),
                if (index == 0)
                  Text(
                    'Total Users Registered',
                    style: TextStyle(fontSize: 20),
                  ),
                if (index == 1)
                  Text('Total Property Registered',
                      style: TextStyle(fontSize: 20)),
                if (index == 2)
                  Text('Total Property Transfered ',
                      style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drawer2() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
        ],
        color: Color(0xFF272D34),
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.person,
            size: 50,
          ),
          SizedBox(
            width: 30,
          ),
          Text('Saurabh',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 80,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, counter) {
                return Divider(
                  height: 2,
                );
              },
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuItemTile(
                  title: menuItems[index].title,
                  icon: menuItems[index].icon,
                  //animationController: _animationController,
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 3) {
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => home_page()));
                    }
                    if (index == 1) getUserList();
                    setState(() {
                      screen = index;
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
