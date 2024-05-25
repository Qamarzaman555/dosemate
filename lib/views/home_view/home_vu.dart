import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosemate/widgets/delete_reminder.dart';
import 'package:dosemate/widgets/uk_appbar.dart';
import 'package:flutter/material.dart';

import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../services/notifications.dart';
import '../../widgets/switcher.dart';
import 'home_vm.dart';

class HomeVU extends StackedView<HomeVM> {
  const HomeVU({super.key});

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: UkAppBar(
          elevation: 3,
          title: 'Hello! ${viewModel.firstName ?? ''} ',
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                viewModel.logOut(context);
              },
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: HorizontalDatePickerWidget(
                  normalColor: Theme.of(context).colorScheme.primary,
                  selectedColor: Theme.of(context).colorScheme.onPrimary,
                  normalTextColor: Theme.of(context).colorScheme.onPrimary,
                  selectedTextColor: Theme.of(context).colorScheme.primary,
                  disabledColor: Theme.of(context).colorScheme.onPrimary,
                  width: 70,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now().add(const Duration(days: 30)),
                  selectedDate: viewModel.selectedDate,
                  widgetWidth: MediaQuery.of(context).size.width,
                  datePickerController: viewModel.datePickerController,
                  onValueSelected: (date) {
                    viewModel.updateSelectedDate(date);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: viewModel.reminderStream(
                        viewModel.user!, viewModel.selectedDate),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        debugPrint('StreamBuilder: Waiting for data...');
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        debugPrint('StreamBuilder: Error - ${snapshot.error}');
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        debugPrint('StreamBuilder: No Reminders');
                        return const Center(child: Text('No Reminders'));
                      }

                      debugPrint('StreamBuilder: Data received');

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          Timestamp t = doc.get('timestamp');
                          DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                              t.microsecondsSinceEpoch);
                          String formattedTime = DateFormat.jm().format(date);
                          viewModel.on = doc.get('onOff');

                          String medicationName = doc.get('name');
                          String dosage = doc.get('dosage');
                          String notes = doc.get('notes');
                          String doseType = doc.get('doseType');

                          Notifications.showNotifications(
                            dateTime: date,
                            id: index,
                            title: 'Medication Reminder: $medicationName',
                            body:
                                'Dosage: $dosage\nNotes: $notes\nDose Type: $doseType',
                          );

                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$formattedTime - $medicationName',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Dosage: $dosage',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Notes: $notes',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Dose Type: $doseType',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Switcher(
                                          onOff: viewModel.on,
                                          uid: viewModel.user!,
                                          timestamp: doc.get('timestamp'),
                                          id: doc.id,
                                          onToggle: (bool value) {
                                            if (value) {
                                              Notifications.showNotifications(
                                                dateTime: date,
                                                id: index,
                                                title:
                                                    'Medication Reminder: $medicationName',
                                                body:
                                                    'Dosage: $dosage\nNotes: $notes\nDose Type: $doseType',
                                              );
                                            } else {
                                              Notifications.cancelNotification(
                                                  id: index);
                                            }
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            deleteReminder(context, doc.id,
                                                viewModel.user!);
                                          },
                                          icon:
                                              const Icon(Icons.delete_outline),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM(context);
}
