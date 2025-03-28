// import 'package:path/path.dart';
//
// class UserTable{
//   static const tableName='User_Reg';
//   static const dbUserId='userId';
//   static  const dbUserName='userName';
//   static const dbUserAge='userAge';
//   static const dbUserAddress='userAddress';
//   static const dbUserDob='userDob';
//
//   final String userId;
//   final String userName;
//   final int  userAge;
//   final  String userAddress;
//   final int userDob;
//
//   UserTable.create({required this.userId,required this.userName,required this.userAge,required this.userAddress,required this.userDob});
//   UserTable.update({ required this.userId,required this.userName,required this.userAge,required this.userAddress,required this.userDob});
//
//   UserTable.fromJson(Map<String,dynamic> json)
//       :
//         userId=json[dbUserId],
//         userName=json[dbUserName],
//         userAge=int.tryParse(json[dbUserAge].toString()) ?? 0,
//         userAddress=json[dbUserAddress],
//         userDob=int.tryParse(json[dbUserDob].toString())??0;
//   UserTable.fromMap(Map<String,dynamic>json)
//       :
//         userId=json[dbUserId],
//         userName=json[dbUserName],
//         userAge=json[dbUserAge],
//         userAddress=json[dbUserAddress],
//         userDob=json[dbUserDob];
//   Map<String,dynamic>toJson(){
//     return {
//       dbUserId:userId,
//       dbUserName:userName,
//       dbUserAge:userAge,
//       dbUserAddress:userAddress,
//       dbUserDob:userDob,
//     };
//
//   }
// }