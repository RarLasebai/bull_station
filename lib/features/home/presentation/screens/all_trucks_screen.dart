import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/screens/truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTrucksScreen extends StatefulWidget {
  const AllTrucksScreen({super.key});

  @override
  State<AllTrucksScreen> createState() => _AllTrucksScreenState();
}

class _AllTrucksScreenState extends State<AllTrucksScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data only once when entering
    context.read<HomeCubit>().getAllTrucks();
  }
  @override
  Widget build(BuildContext context) {
    final homeCubit = HomeCubit.get(context);
    homeCubit.getAllTrucks();

    return Scaffold(
      appBar: TopNavBar("كل العروض"),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocBuilder<HomeCubit, HomeStates>(
            buildWhen: (previous, current) {
    // Only rebuild this screen if the state is related to the "List" of trucks
    return current is HomeLoadingState || current is GetLatestTrucksSuccessState;
  },
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return LoadingWidget();
              } 
              else if (state is GetLatestTrucksSuccessState) {
                if (state.trucks.isEmpty) {
                  return const Center(child: Text("لا توجد معدات بعد"));
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ...state.trucks.map(
                          (truck) => InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: homeCubit,
                                  child: TruckDetailsScreen(
                                    id: truck.id,
                                    homeCubit: homeCubit,
                                  ),
                                ),
                              ),
                            ),
                            child: TruckCardWidget(truckCardModel: truck),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: Text("حدث خطأ ما!"));
              }
            },
          ),
        ),
      ),
    );
  }
}
