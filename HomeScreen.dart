import 'dart:convert';
import 'package:crypto_app/CoinDetail.dart';
import 'package:crypto_app/Updateprofilescreen.dart';
import 'package:crypto_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String Url ='https://pro-api.coingecko.com/api/v3/coins/markets?vs_currency=INR';
  String Name = "", Email = "", Age = "";
  bool isDarkMode = AppTheme.isDarkModeEnabled;
  GlobalKey<ScaffoldState>_globalKey =GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getUserDetail();
    getCoinDetails();
  }

  void getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Name = prefs.getString("Name") ?? "";
      Email = prefs.getString("Email") ?? "";
      Age = prefs.getString("Age") ?? "";
    });
  }

  Future<List<CoinDetails>> getCoinDetails() async{
    Uri uri = Uri.parse(Url);

   final response = await http.get(uri);
   if(response.statusCode == 200 || response.statusCode ==201){
     List coinData = json.decode(response.body);

     List<CoinDetails> data = coinData.map((e) => CoinDetails.fromJson(e)).toList();

     return data;
   }else{
     return<CoinDetails>[];
   }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _globalKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Crypto_App", style: TextStyle(color: Colors.black),),
      ),
      drawer: Drawer(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                " Name : $Name",
                style: TextStyle(fontSize: 15),
              ),
              accountEmail: Text("Email :$Email\nAge =$Age",
                  style: TextStyle(fontSize: 15)),
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 70,
                color: Colors.white,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(),
                  ),
                );
              },
              leading: Icon(Icons.account_box,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                "Update Profile",
                style: TextStyle(
                    fontSize: 17,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isDarkMode", isDarkMode);
                setState(() {
                  isDarkMode = !isDarkMode;
                });
                AppTheme.isDarkModeEnabled = isDarkMode;
                await prefs.setBool("isDarkMode", isDarkMode);
              },
              leading: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkMode ? Colors.white : Colors.black),
              title: Text(
                isDarkMode ? "Light Mode" : "Dark Mode",
                style: TextStyle(
                    fontSize: 17,
                    color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
           Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 40
        ),
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40)
              ),
              hintText: "Search Coin Here"
          ),
        ),
           ),

            Expanded(
              child: FutureBuilder(
                future: getCoinDetails(),
                  builder: (context,AsyncSnapshot<List<CoinDetails>> snapshot){
                if(snapshot.hasData){
                  return Column(children: [
                    Expanded(child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context,index) {

                        return coinDetails(snapshot.data![index]);
                      },
                    ),)
                  ],);

                }
                else{
                  return const Center(child:Text("Error display"));
                }
              }
              )
            ),
    ]
      ),
    ),
    );
  }

  Widget coinDetails(CoinDetails model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10),
      child: ListTile(
        leading: Image.network(model.image!),
        title: Text("${model.image}\n${model.symbol}",
        style: TextStyle(fontSize: 15,
        fontWeight: FontWeight.w500
        ),
        ),
        trailing: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
              text: "Rs.${model.currentPrice}\n",
          style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black),
          children: [
            TextSpan(
              text: "${model.priceChangePercentage24h}%",
              style: TextStyle(fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,),
            )
          ]
        ),
        ),
      ),
    );
  }
}
