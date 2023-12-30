import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:gsheets/gsheets.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-378608",
  "private_key_id": "ab209641186ff4b5ae4c111a40a6c3327b106437",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCpIlc1M5OEZ4os\nCtlsO07wmfk1fg3M39JEKtBEHp4DQEKekNWA33rDY5TrdBxl6PZ1IKBtKzVqZDFX\nT/1Nt9jsX9xWMFIFnvcWUovQsnvTxnPdWjR/pVg4e8cpGGEJk4XERixku0F0oKHc\npVj4wDTRa7HKmy6T2JmYOom0N/Ycoltkr/dWAmaGbgS+9gmvmkjkFMqWf0ryaInM\nCuX5uPeqOf5mTdAM1CNe462Ca6QqaMiyyxCHslmpI99yl12rg5WL4zpdAnP3K5T/\nUASBT3lvHFoH0ZPUuJaXFok8Vgaa4GWInNEF5ido23rvDMiEad6yrnHzLP0jwM/G\nFCfatT1VAgMBAAECggEABs/WwlJG9TS0WGzBb/39gmw5IMHobWFwVwWAaNXw2EGs\nzTUZHD0j9R2cIFWHVUVqM7JyM6NjXdsWL6WNlqU6a966gZAlpYtO+UuuzON7YD6k\naPxak++FW5UEou+T7O5Pm2WWISJ3kuprSncwW6hmGC8ltHrGh/bXzM1CwYrlcya4\nAZ+L6FhfpWiydczFMvd4NvxatYR0Q1N9YfOWF6hoS/GsrMfMxRdTbJ7Ng8HTlkH8\n4zpkChj4pZ/Vr6yiPD/TahgG4f83HxMpCloc9iJrLGMzWZcScjAG+rMwpHhXKG+/\nvqMldWYeWCV3WMeY8CvvfXtQFXroAo3XrhqYwk1g4QKBgQDkFVejtxDZ36QupL8u\nzZZx43vMQkAaiCiuM7SzOf//b7402EOdM3x+f7GAD3eXEgeTlQOvNa1tyW6c3kdj\n2CyCS8jwmaDCYr9ufE/k78iIrKL1FGCPw2UNBZ/hmSnaT3SZmFzviUatMNoCavem\nOMs4xgtJpxVrWQ3irsF9byVLhQKBgQC91eks4nftXqT+Wk0QvJwX8K9UkF0VLsVw\nSJEpqCeKWvozIXbSBFjnQ/HQF5sg0vo9lPM9xoA3zmW/jC7QkYcd7UfTiE5uGK/W\nQL4kGlck3G5EJApA5wrHtyzpIyZjyx1ppu/npCNbi3t7f6zNWzLUiQBO3r0tdiO/\nwR9Ge9fLkQKBgF8PDhGrkJhdfx35h7zH7nXU65m72t+z89B2uE8iUzFwrwNzRurT\ntIU8TwwiZiNOXl4B8yEo6/kfxLwYYASa6iH71+l+/eNGKKaxpNKzpQ5hdSFTttL0\nCr+con/xx+G2z8/cEo+61PwFqjbrwf9DGF+3Gqk9u82btg/N6dKPainJAoGADJ4f\nNYCIABr+VHmkDay7o0u4G6LMzQ+ix+fK3j3zAtsxLhzXTPZFAnodpHstMG1VfKpd\n0IlVFGB/ms+yfOJvXKnc0E6LB/5UEaWT/cpSaHzOR3EtzUqOCOA/9+8CKjfh6JfT\n8k2SnA8VUgwWbD/XjRDeGF/tqwvjLGelsIWivkECgYATMH46A/y3tFRHyw/cAe/G\n9YU0v1QPEyWCeOT7IUQ8oMFFMVIjMPL3tfIoQEiW1VOaDu/qiypB798tFaVv0c+0\nFOFHKmVgRmHAiwRBdFIk21PD3rXodw4Oa3mfQrikbjiaAJYYZ2u1kuFawj9ZcWSW\nHklVi6d/wdr8m+Gu2Cd77w==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-378608.iam.gserviceaccount.com",
  "client_id": "100403251199722142563",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-378608.iam.gserviceaccount.com"
}

''';
const _spreadsheetId = '1MiH1nFMumC9oKsFrvjNdSRIavn28FCJv6K0f6aEdsmQ';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)  {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'XYZ Organization'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db = FirebaseFirestore.instance;
  List<String> itemList = [];
  String location="[ALL]";

  List<String> catList = [];
  String category="[ALL]";

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCategories();
  }
  Future<void> fetchCategories() async {
    final CollectionReference itemRef=FirebaseFirestore.instance
        .collection("contacts");
    QuerySnapshot querySnapshot=await itemRef.get();

    List<String> tempItemList=[];
    tempItemList.add("[ALL]");
    querySnapshot.docs.forEach((doc) {
      if(!tempItemList.contains(doc['category'].toString()))
        tempItemList.add(doc['category'].toString());
    });

    setState(() {
      catList=tempItemList;
    });
  }

  Future<void> fetchData() async {
    final CollectionReference itemRef=FirebaseFirestore.instance
                                        .collection("contacts");
    QuerySnapshot querySnapshot=await itemRef.get();

    List<String> tempItemList=[];
    tempItemList.add("[ALL]");
    querySnapshot.docs.forEach((doc) {
      if(!tempItemList.contains(doc['location'].toString()))
        tempItemList.add(doc['location'].toString());
    });

    setState(() {
      itemList=tempItemList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
       mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          /*
          ElevatedButton(
              onPressed: exportData,
              child: Text("Export CSV")),

           */
          ElevatedButton(
              onPressed: readDatafromGSheet,
              child: Text("Read Google Sheets")),

          chips2(),

          Expanded(
              child: contactListView()),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void readDatafromGSheet() async {
    final CollectionReference contacts=FirebaseFirestore
        .instance
        .collection("contacts2");
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('contacts');
    int rows=sheet!.rowCount;

    var cellsRow;
    for(var i=1; i< rows; i++)
    {
      cellsRow = await sheet.cells.row(i);
      print(cellsRow.elementAt(2).value);
      var record = {
        "category": cellsRow.elementAt(1).value,
        "name": cellsRow.elementAt(2).value,
        "cell_no": cellsRow.elementAt(3).value,
        "position": cellsRow.elementAt(4).value,
        "location": cellsRow.elementAt(5).value,
        "email": cellsRow.elementAt(6).value,
      };
      contacts.add(record);
    }

  }







  void readDatafromGSheet01() async {
    final CollectionReference contacts=FirebaseFirestore
        .instance
        .collection("contacts3");
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('firebase_users');
    int rows=sheet!.rowCount;

    var cellsRow;
    for(var i=1; i< rows; i++)
    {
      cellsRow = await sheet.cells.row(i);
      print(cellsRow.elementAt(2).value);
      var record = {
        "category": cellsRow.elementAt(1).value,
        "name": cellsRow.elementAt(2).value,
        "cell_no": cellsRow.elementAt(3).value,
        "position": cellsRow.elementAt(4).value,
        "location": cellsRow.elementAt(5).value,
        "email": cellsRow.elementAt(6).value,
      };
      contacts.add(record);
    }

  }
  AppBar MyAppBar() {
    return AppBar(
      title: Column(
        children: [
         // Text(widget.title),

          LocationDropDown()
        ],),

      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.info, size: 40),
          onTap: null,
        ),
        SizedBox(width: 10,),
        GestureDetector(
          child: Icon(Icons.help, size: 40),
          onTap: null,
        ),
      ],


    );
  }
  Widget dropdown() {
    return Center(
      // check if data has been retrieved from Firestore
      child: itemList.isEmpty
      // show loading indicator while data is being fetched
          ? CircularProgressIndicator()
          : DropdownButton<String>(
        value: location,
        onChanged: (newValue) {
          setState(() {
            // update state with new value selected from dropdown list
            location = newValue.toString();
          });
        },
        items: itemList // populate dropdown list with items from Firestore
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  Widget LocationDropDown() {
    return  Center(
      child: itemList.isEmpty
              ? CircularProgressIndicator()
              : DropdownButton(
                    value: location,
                    items: itemList.map<DropdownMenuItem<String>>((String val)
                    {
                      return DropdownMenuItem(
                        value: val,
                          child: Text(val));
                    }

                    ).toList(),
                    onChanged: (newValue) {
                      setState(() {
                          location=newValue.toString();
                      });
                    }
                  )
    );
  }

  Widget chips2() {
    return Wrap(
      spacing: 8.0, // spacing between chips
      runSpacing: 4.0, // spacing between rows of chips
      children: catList.map((String item) {
        return myChip(item);
      }).toList(),
    );
  }



  Widget chips()
  {
    List<String> list=[];
    list.clear();
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return StreamBuilder <QuerySnapshot>(
          stream: db.collection("contacts").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Wrap(
                children: snapshot.data!.docs.map((doc) {
                  if(list.contains(doc['category'].toString()))
                    return SizedBox.shrink();
                  else {
                    list.add(doc['category'].toString());
                    return myChip(doc['category'].toString());

                  }
                }).toList(),
            );
        }
        );

      },
    );
  }

  Widget myChip(String label) {

    return GestureDetector(
      onTap: () {
        setState(() {
          category=label;
        });

      },
      child: Container(
        child: Chip(
          labelPadding: EdgeInsets.only(left: 8.0, right: 8),
          label: Text(
            label,
            style: TextStyle(
              fontSize: 12,

            ),
          ),
          backgroundColor: category==label  ? Colors.amber : Colors.deepOrange,
          elevation: 6.0,
          shadowColor: Colors.grey[60],
          padding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }

  void exportData() async {
    final CollectionReference contacts=FirebaseFirestore
                                            .instance
                                            .collection("contacts");
    final myData=await rootBundle.loadString("res/contacts.csv");

    List<List<dynamic>> csvTable=CsvToListConverter().convert(myData);

    List<List<dynamic>> data=[];

    data=csvTable;

    for(var i=0; i< data.length; i++)
      {
        var record = {
          "category": data[i][1],
          "name": data[i][2],
          "cell_no": data[i][3],
          "position": data[i][4],
          "location": data[i][5],
          "email": data[i][6],
        };
        contacts.add(record);
      }


  }



  Widget contactListView() {
    return FutureBuilder(
          future:  Firebase.initializeApp(),
          builder: (context, snapshot) {

            return StreamBuilder<QuerySnapshot>(
              stream: location=="[ALL]"
                      ? category=="[ALL]"
                          ? db.collection('contacts').snapshots()
                          : db.collection('contacts')
                                .where("category", isEqualTo: category)
                                .snapshots()
                      : category=="[ALL]"
                         ? db.collection('contacts')
                                  .where("location", isEqualTo: location)
                                  .snapshots()
                          : db.collection('contacts')
                            .where("location", isEqualTo: location)
                            .where("category", isEqualTo: category)
                            .snapshots(),
            builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return Contact(doc);
                    }).toList(),
                  );
              },
            );
          }

    );
  }
//Text(doc.data()['name'])
  Widget Contact(QueryDocumentSnapshot doc) {
    return Card(
      child: Row(
          children: [
            Flexible(
                flex: 4,
                child: Column(
                  children: [

                    Text(doc['name'],
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    Text(doc['position'],
                      style: TextStyle(fontSize: 12, ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,),
                    Row(
                      children: [
                        Expanded(child: Text(doc['location'],style: TextStyle(fontFamily: "Montserrat", fontSize: 12),textAlign: TextAlign.left,softWrap: true)),
                        Container(
                            color: Colors.black87,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                            child: Text(doc['category'],style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.right,softWrap: false)
                        ),

                      ],
                    )
                  ],
                )
            ),
            Flexible(
                flex: 1,
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () { phoneCall(doc['cell_no']);},
                        icon: Icon(Icons.call)),
                    IconButton(
                        onPressed:() { _sendSMS(doc['cell_no']);},
                        icon: Icon(Icons.textsms_outlined)),
                    IconButton(
                        onPressed: () { sendWhatsApp(doc['cell_no']); },
                        icon: Image.asset('res/icons/whatsapp.png')),

                  ],
                )
            )
          ],
        ),
    );
  }
  void phoneCall(String phoneNo) {
    launch("tel://"+ phoneNo);
  }

  void _sendSMS(String recepient) async {
    List<String> recepients=[recepient];
    await sendSMS(message: "", recipients: recepients);
  }

  void sendWhatsApp(String phoneNo) {
    String url="whatsapp://send?$phoneNo";
    launchUrl(Uri.parse(url));
  }



  void readGSheet() async {
    // init GSheets
    final gsheets = GSheets(_credentials);
    // fetch spreadsheet by its id
    final ss = await gsheets.spreadsheet(_spreadsheetId);

    print(ss.data.namedRanges.byName.values
        .map((e) => {
      'name': e.name,
      'start':
      '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
      'end':
      '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
    })
        .join('\n'));

    // get worksheet by its title
    var sheet = ss.worksheetByTitle('example');
    // create worksheet if it does not exist yet
    sheet ??= await ss.addWorksheet('example');

    // update cell at 'B2' by inserting string 'new'
    await sheet.values.insertValue('new', column: 2, row: 2);
    // prints 'new'
    print(await sheet.values.value(column: 2, row: 2));
    // get cell at 'B2' as Cell object
    final cell = await sheet.cells.cell(column: 2, row: 2);
    // prints 'new'
    print(cell.value);
    // update cell at 'B2' by inserting 'new2'
    await cell.post('new2');
    // prints 'new2'
    print(cell.value);
    // also prints 'new2'
    print(await sheet.values.value(column: 2, row: 2));

    // insert list in row #1
    final firstRow = ['index', 'letter', 'number', 'label'];
    await sheet.values.insertRow(1, firstRow);
    // prints [index, letter, number, label]
    print(await sheet.values.row(1));

    // insert list in column 'A', starting from row #2
    final firstColumn = ['0', '1', '2', '3', '4'];
    await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
    // prints [0, 1, 2, 3, 4, 5]
    print(await sheet.values.column(1, fromRow: 2));

    // insert list into column named 'letter'
    final secondColumn = ['a', 'b', 'c', 'd', 'e'];
    await sheet.values.insertColumnByKey('letter', secondColumn);
    // prints [a, b, c, d, e, f]
    print(await sheet.values.columnByKey('letter'));

    // insert map values into column 'C' mapping their keys to column 'A'
    // order of map entries does not matter
    final thirdColumn = {
      '0': '1',
      '1': '2',
      '2': '3',
      '3': '4',
      '4': '5',
    };
    await sheet.values.map.insertColumn(3, thirdColumn, mapTo: 1);
    // prints {index: number, 0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6}
    print(await sheet.values.map.column(3));

    // insert map values into column named 'label' mapping their keys to column
    // named 'letter'
    // order of map entries does not matter
    final fourthColumn = {
      'a': 'a1',
      'b': 'b2',
      'c': 'c3',
      'd': 'd4',
      'e': 'e5',
    };
    await sheet.values.map.insertColumnByKey(
      'label',
      fourthColumn,
      mapTo: 'letter',
    );
    // prints {a: a1, b: b2, c: c3, d: d4, e: e5, f: f6}
    print(await sheet.values.map.columnByKey('label', mapTo: 'letter'));

    // appends map values as new row at the end mapping their keys to row #1
    // order of map entries does not matter
    final secondRow = {
      'index': '5',
      'letter': 'f',
      'number': '6',
      'label': 'f6',
    };
    await sheet.values.map.appendRow(secondRow);
    // prints {index: 5, letter: f, number: 6, label: f6}
    print(await sheet.values.map.lastRow());

    // get first row as List of Cell objects
    final cellsRow = await sheet.cells.row(1);
    // update each cell's value by adding char '_' at the beginning
    cellsRow.forEach((cell) => cell.value = '_${cell.value}');
    // actually updating sheets cells
    await sheet.cells.insert(cellsRow);
    // prints [_index, _letter, _number, _label]
    print(await sheet.values.row(1));
  }

}
