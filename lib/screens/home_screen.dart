import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_tanker_worker/blocs/theme_bloc.dart';
import 'package:water_tanker_worker/events/theme_event.dart';
import 'package:water_tanker_worker/states/theme_state.dart';
import '../blocs/home_bloc.dart';
import '../events/home_event.dart';
import '../states/home_state.dart';
import '../utils/mediaquery.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHelper = MediaQueryHelper(context);

    return BlocBuilder<ThemeBloc, ThemeState>(builder: (context, themeState) {
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, homeState) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "Worker Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    themeState.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    context.read<ThemeBloc>().add(ToggleThemeEvent());
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(mediaQueryHelper.scaledWidth(0.05)),
              child: Stack(
                children: [
                  if (homeState.isFetchingOrders) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else if (homeState.assignedOrder == null) ...[
                    ListView.builder(
                      itemCount: homeState.orders.length,
                      itemBuilder: (context, index) {
                        final order = homeState.orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('Order #${order.id}'),
                            subtitle:
                                Text('${order.numberOfTanks} tanks, ${order.location}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<HomeBloc>()
                                    .add(AssignOrderEvent(order.id));
                              },
                              child: const Text('Assign to Me'),
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                            'Assigned Order #${homeState.assignedOrder!.id}'),
                        subtitle: Text(
                            '${homeState.assignedOrder!.numberOfTanks} tanks, ${homeState.assignedOrder!.location}'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Navigate to track order location
                            Navigator.pushNamed(context, '/trackOrder',
                                arguments: homeState.assignedOrder!.id);
                          },
                          child: const Text('Track Location'),
                        ),
                      ),
                    ),
                  ],
                  Positioned(
                    top: 0,
                    left: mediaQueryHelper.scaledWidth(0),
                    right: mediaQueryHelper.scaledWidth(0),
                    child: GestureDetector(
                      onTap: () {
                        context.read<HomeBloc>().add(UpdateLocationEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: themeState.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: themeState.themeMode == ThemeMode.dark
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                homeState.currentLocationName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize:
                                        mediaQueryHelper.scaledFontSize(0.04)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
