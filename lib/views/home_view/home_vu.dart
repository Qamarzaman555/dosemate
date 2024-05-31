import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosemate/utils/utils.dart';
import 'package:dosemate/widgets/delete_reminder.dart';
import 'package:dosemate/widgets/uk_appbar.dart';
import 'package:flutter/material.dart';

import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../services/notifications.dart';
import '../../widgets/checker.dart';
import 'home_vm.dart';

class HomeVU extends StackedView<HomeVM> {
  const HomeVU({super.key});

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: customAppBar(viewModel, context),
        body: SafeArea(
          child: Column(
            children: [
              datePicker(context, viewModel),
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

                      return remindersList(snapshot, viewModel);
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

  UkAppBar customAppBar(HomeVM viewModel, BuildContext context) {
    return UkAppBar(
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
    );
  }

  Widget datePicker(BuildContext context, HomeVM viewModel) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
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
    );
  }

  Widget remindersList(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot, HomeVM viewModel) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        Timestamp t = doc.get('timestamp');
        DateTime date =
            DateTime.fromMicrosecondsSinceEpoch(t.microsecondsSinceEpoch);
        String formattedTime = DateFormat.jm().format(date);
        bool on = doc.get('onOff');

        String medicationName = doc.get('name');
        String dosage = doc.get('dosage');
        String notes = doc.get('notes');
        String doseType = doc.get('doseType');

        Widget doseTypeIcon = viewModel.getDoseTypeIcon(doseType);

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 3)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 16, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 12),
                    child: doseTypeIcon,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(doseType,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Row(
                              children: [
                                Text(on ? 'Already taken' : 'Mark as taken',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold)),
                                Checker(
                                  onOff: on,
                                  uid: viewModel.user!,
                                  timestamp: doc.get('timestamp'),
                                  id: doc.id,
                                  onToggle: (value) {
                                    value
                                        ? Notifications.cancelNotification(
                                            id: index)
                                        : Notifications.showNotifications(
                                            dateTime: date,
                                            id: index,
                                            title:
                                                'Medication Reminder: $medicationName',
                                            body:
                                                'Dosage: $dosage\nNotes: $notes\nDose Type: $doseType',
                                          );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'Medication Name: $medicationName',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dosage: $dosage',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(formattedTime,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notes: $notes',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              InkWell(
                                  onTap: () {
                                    deleteReminder(
                                        context, doc.id, viewModel.user!);
                                  },
                                  child: customImage(
                                      height: 20.0,
                                      width: 20.0,
                                      'assets/bin.png')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM(context);
}
