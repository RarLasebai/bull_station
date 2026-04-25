// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:plants_project/core/app_cubit/app_cubit.dart';
// import 'package:plants_project/core/utils/colors/colors.dart';
// import 'package:plants_project/features/auth/application/auth_cubit/auth_cubit.dart';
// // 
// import '../../app_cubit/app_states.dart';

// class HomeLayout extends StatelessWidget {
//   const HomeLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (BuildContext context) => AppCubit()),
//         BlocProvider(
//             create: (BuildContext context) =>
//                 AuthCubit()..getDataFromSharedPref()),
//       ],
//       child: BlocConsumer<AppCubit, AppStates>(
//           listener: (context, state) {},
//           builder: (context, appState) {
//             AppCubit appCubit = AppCubit.get(context);
//             return Scaffold(
//               resizeToAvoidBottomInset: true,
//               body: appCubit.screens[appCubit.currentIndex],
//               bottomNavigationBar: ClipRRect(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(23.r),
//                 ),
//                 child: Container(
//                   height: 75.h,
//                   color: const Color(0xffACDFC9).withOpacity(.45),
//                   width: MediaQuery.of(context).size.width.sp,
//                   child: Theme(
//                     data: Theme.of(context).copyWith(
//                       canvasColor: const Color(0xffACDFC9).withOpacity(.45),
//                     ),
//                     child: BottomNavigationBar(
//                       elevation: 0,
//                       onTap: ((value) {
//                         appCubit.changeBottomNavBarScreen(value);
//                       }),
//                       unselectedItemColor: secondaryFont,
//                       showUnselectedLabels: false,
//                       currentIndex: appCubit.currentIndex,
//                       selectedItemColor: secondaryFont,
//                       selectedLabelStyle: TextStyle(
//                         overflow: TextOverflow.ellipsis,
//                         fontFamily: 'InriaSans',
//                         fontSize: 14.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       backgroundColor: const Color(0xffACDFC9).withOpacity(.45),
//                       items: const [
//                         BottomNavigationBarItem(
//                           icon: ImageIcon(
//                             AssetImage("assets/icons/home.png"),
//                           ),
//                           label: "HOME",
//                         ),
//                         BottomNavigationBarItem(
//                           icon: ImageIcon(
//                             AssetImage("assets/icons/heart.png"),
//                           ),
//                           label: "FAVORITE",
//                         ),
//                         BottomNavigationBarItem(
//                             icon: ImageIcon(
//                               AssetImage("assets/icons/orders.png"),
//                             ),
//                             label: "ORDERS"),
//                             BottomNavigationBarItem(
//                             icon: Icon(Icons.person, color: primaryDark),
//                             label: "PROFILE"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//     );
//   }
// }
