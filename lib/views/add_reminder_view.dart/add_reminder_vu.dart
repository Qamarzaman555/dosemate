import 'package:dosemate/utils/utils.dart';
import 'package:dosemate/widgets/drop_down_item.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
import '../../services/session_manager.dart';
import '../../widgets/uk_appbar.dart';
import '../../widgets/uk_text_button.dart';
import 'add_reminder_vm.dart';

class AddReminderVU extends StackedView<AddReminderVM> {
  const AddReminderVU({super.key});

  @override
  Widget builder(BuildContext context, AddReminderVM viewModel, Widget? child) {
    return Scaffold(
      appBar: UkAppBar(
        title: 'Add Medication',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select a Date and Time for Reminder'),
                20.spaceY,
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: HorizontalDatePickerWidget(
                      normalColor: Colors.transparent,
                      disabledColor: Colors.transparent,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      normalTextColor: Theme.of(context).colorScheme.primary,
                      selectedTextColor:
                          Theme.of(context).colorScheme.onPrimary,
                      width: 70,
                      height: 70,
                      startDate: DateTime.now(),
                      endDate: viewModel.endDate,
                      selectedDate: viewModel.selectedDate,
                      widgetWidth: MediaQuery.of(context).size.width,
                      datePickerController: viewModel.datePickerController,
                      onValueSelected: (date) {
                        viewModel.updateSelectedDate(date);
                      },
                    ),
                  ),
                ),
                20.spaceY,
                UkTextButton(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (newTime != null) {
                      viewModel.updateSelectedTime(newTime);
                    }
                  },
                  text: Row(
                    children: [
                      Text(viewModel.time.format(context).toString()),
                    ],
                  ),
                ),
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Medication Name'),
                  onChanged: viewModel.updateName,
                ),
                20.spaceY,
                const Text('Notes'),
                Wrap(
                  spacing: 8.0,
                  children: ['Before Meal', 'After Meal']
                      .map((note) => ChoiceChip(
                            label: Text(note),
                            selected: viewModel.selectedNote == note,
                            onSelected: (bool selected) {
                              viewModel
                                  .updateSelectedNote(selected ? note : null);
                            },
                          ))
                      .toList(),
                ),
                20.spaceY,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Dose Type'),
                  value: viewModel.selectedDoseType,
                  items: viewModel.doseTypeModel.map((doseTypeModel) {
                    return DropdownMenuItem<String>(
                      value: doseTypeModel.doseType,
                      child: DropdownItem(
                        icon: doseTypeModel.icon!,
                        text: doseTypeModel.doseType!,
                      ),
                    );
                  }).toList(),
                  onChanged: viewModel.updateSelectedDoseType,
                ),
                20.spaceY,
                if (viewModel.selectedDoseType != null) ...[
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    children: viewModel.doseOptions[viewModel.selectedDoseType]!
                        .map((dose) => ChoiceChip(
                              label: Text(dose),
                              selected: viewModel.selectedDose == dose,
                              onSelected: (bool selected) {
                                viewModel
                                    .updateSelectedDose(selected ? dose : null);
                              },
                            ))
                        .toList(),
                  ),
                ],
                40.spaceY,
                UkTextButton(
                  onPressed: viewModel.isBusy
                      ? null
                      : () {
                          viewModel.addReminder(
                              context, SessionController().userId!);
                        },
                  label:
                      viewModel.isBusy ? 'Adding Reminder...' : 'Add Reminder',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  AddReminderVM viewModelBuilder(BuildContext context) => AddReminderVM();
}
