// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


ValueNotifier<List<BillDetailsModel>>billListNotifier=ValueNotifier([]);
ValueNotifier<List<BillDetailsModel>>dueBillNotifier=ValueNotifier([]);
ValueNotifier<List<BillDetailsModel>>revenueNotifier=ValueNotifier([]);

Future <void>addBill(BillDetailsModel value)async{
  final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
  final bookingid=await billDB.add(value);
  value.bookingId=bookingid;

  SharedPreferences sharedPrefs=await SharedPreferences.getInstance();
  int currentBillNo=sharedPrefs.getInt('currentBillNo')?? 1;
  int nextBillNo=currentBillNo+1;
  await sharedPrefs.setInt('currentBillNo', nextBillNo);
}

Future<int>nextBillNo()async{
  SharedPreferences sharedPrefs=await SharedPreferences.getInstance();
  int currentBillNo=sharedPrefs.getInt('currentBillNo')?? 1;
  // int nextBillNo=currentBillNo+1;
  // await sharedPrefs.setInt('currentBillNo', nextBillNo);
  return currentBillNo;
}
       
Future <void>getBillDetails()async{
  final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
  billListNotifier.value.clear();
  billListNotifier.value.addAll(billDB.values);
  billListNotifier.notifyListeners();
}

Future<void>updateBill(int settledBillNo,billingDate,clickedBillIndex)async{

  final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
  final bill=billDB.values.elementAt(clickedBillIndex);
  if(bill.billNo==settledBillNo){
    bill.isSettled=true;
    bill.billingDate=billingDate;
    await billDB.put(clickedBillIndex, bill);
  }  
}

Future<void>getDueBill()async{
  final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
  final currentDate=DateTime.now();
  final dueBills=billDB.values.where((bill) =>  DateFormat('MMM d, yyyy').parse(bill.returnDate).
  isBefore(currentDate)|| DateFormat('MMM d, yyyy').parse(bill.returnDate)==currentDate) ;
  final bill=dueBills.where((element) => element.isSettled==false);
  dueBillNotifier.value.clear();
  dueBillNotifier.value.addAll(bill);
  dueBillNotifier.notifyListeners();
}

Future<List<BillDetailsModel>>searchText(String searchText)async{
 
  final productDB= await Hive.openBox<BillDetailsModel>('bill_db');
  
    final results=productDB.values
    .where((product) =>
    
    product.customerName.contains(searchText)||
    product.customerMobileNo.contains(searchText)
   ).toList();
   
    return results;
  
  }
  Future<Iterable<BillDetailsModel>>getSettledBill()async{
    final billDB=await Hive.openBox<BillDetailsModel>('bill_db');
    final settledBills=billDB.values.where((element) => element.isSettled==true);
    return settledBills;
  }

Future<double>getRevenue(String fromDate,String toDate)async{
  final billDB= await Hive.openBox<BillDetailsModel>('bill_db');
  final df = DateFormat('MMM d, yyyy'); // Specify the expected format
  DateTime fromdate = df.parse(fromDate);
  DateTime todate = df.parse(toDate);
  
  final settledbills=billDB.values.where((element) => element.isSettled==true);
  
  final billsWithinRange= fromdate!=todate? settledbills.where((element) =>
  df.parse(element.billingDate!).isAfter(fromdate.subtract(const Duration(days: 1)))&&
  df.parse(element.billingDate!).isBefore(todate.add(const Duration(days: 1)))
  ):
  settledbills.where((element) => df.parse(element.billingDate!)==todate);

  double totalRevenue = 0.0;
  for(var bill in billsWithinRange){
    totalRevenue = totalRevenue+ bill.totalAmount; 
  } 
  revenueNotifier.value.clear();
  revenueNotifier.value.addAll(billsWithinRange);
  revenueNotifier.notifyListeners();
  return totalRevenue;
}

