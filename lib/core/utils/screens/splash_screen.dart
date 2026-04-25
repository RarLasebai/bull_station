import 'dart:async';

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/features/auth/application/auth_cubit/auth_cubit.dart';
import 'package:bull_station/features/auth/application/auth_cubit/auth_states.dart';
import 'package:bull_station/features/auth/presentation/screens/login_screen.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/presentation/screens/home_screen.dart';
import 'package:bull_station/features/home/presentation/screens/owner_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthCubit()..checkSign(),

      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: SizedBox(
                  width: 250.w,
                  // height: 150.h,
                  child: Image.asset(
                    "assets/images/logo_white.png",
                    fit: BoxFit.fitWidth,
                    height: 300.h,
                  ),
                ),
              ),
            ),

            SpinKitThreeInOut(color: darkBlue, size: 50),
            BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, authState) {
                if (authState is AuthSuccessState) {
                  final String accountType = authState.userModel.accountType;
                  final homeCubit = context.read<HomeCubit>();
                  Timer(const Duration(seconds: 2), () {
                    if (accountType == "client") {
                      homeCubit.getAllTrucks();
                    } else {
                      homeCubit.getMyTrucks();
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => accountType != "client"
                            ? OwnerHomeScreen()
                            : HomeScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  });
                } else if (authState is AuthFailState) {
                  {
                    Timer(
                      const Duration(seconds: 3),
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      ),
                    );
                  }
                } else if (authState is AuthErrorState) {
                  showToast(context, authState.message);
                }
              },
              builder: (context, authState) {
                if (authState is AuthLoadingState) {
                  return const LoadingWidget();
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
    // );
  }
}
