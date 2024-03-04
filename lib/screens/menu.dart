import 'package:flutter/material.dart';
import 'package:rental_app/db/model/menu_item_model.dart';
import 'package:rental_app/screens/bill_settlement.dart';
import 'package:rental_app/screens/due_orders.dart';
import 'package:rental_app/screens/login_screen.dart';
import 'package:rental_app/screens/revenue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  Menu({super.key});
  final List<MenuItem> items = [
    MenuItem(title: 'Bill', leadingIcon: const Icon(Icons.receipt),trailingIcon:const  Icon(Icons.chevron_right,)),
    MenuItem(title: 'Revenue', leadingIcon: const Icon(Icons.money),trailingIcon: const Icon(Icons.chevron_right)),
    MenuItem(title: 'Due order', leadingIcon: const Icon(Icons.chat_bubble_outline_rounded),trailingIcon: const Icon(Icons.chevron_right)),
    MenuItem(title: 'Logout', leadingIcon: const Icon(Icons.logout),trailingIcon: const Icon(Icons.chevron_right)),
    
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor: const Color(0xffC8B6B6),
      appBar: AppBar(
        backgroundColor: const Color(0xff8ECFCB),
        title: const Center(child: Text('Additional Information')),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(10.0 ),
        child: ListView.builder(
          itemBuilder: (context,index){
            return ListTile(
              title: Text(items[index].title),
              leading: Icon(items[index].leadingIcon.icon),
              trailing: GestureDetector(
                onTap: () {
                  if(items[index].title=='Bill'){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const BillSettlement()));
                  }
                  else if(items[index].title=='Revenue'){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Revenue()));
                  }
                  else if(items[index].title=='Due order'){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const DueOrders()));
                  }
                  else{
                    signoutAlert(context);

                  }
                },
                child: Icon(items[index].trailingIcon.icon)),
            );
        
          },
          itemCount: items.length,
          ),
      )),
    );
  }

  signoutAlert(BuildContext context){

  showDialog(
    context: context,
     builder: ((context) {
       return  AlertDialog(
        title: const Text('Alert'),
        content: const Text('Do you want to  logout?'),
        actions: [
          TextButton(onPressed: (){
            signout(context);

          }, child: const Text('YES')),
          TextButton(onPressed: (){
            Navigator.of(context).pop();

          }, child: const Text('NO')),
        ],
       );
     }));
}
signout(BuildContext ctx)async {   
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx1)=>LoginScreen()), (route) => false);
}
}