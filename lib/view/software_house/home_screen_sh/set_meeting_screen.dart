import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/utilis/toast_msg.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/view/software_house/bottom_screen_sh/bottom_screen_sh.dart';
import 'package:table_calendar/table_calendar.dart';

class SetMeetingScreen extends StatefulWidget {
  final String jobId;
  final String userId;
  const SetMeetingScreen(
      {super.key, required this.jobId, required this.userId});

  @override
  State<SetMeetingScreen> createState() => _SetMeetingScreenState();
}

class _SetMeetingScreenState extends State<SetMeetingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedStatus = "Approved";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whitecolor),
        title: Text(
          "Set Meeting",
          style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
        ),
        backgroundColor: themecolor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Meeting Date:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedTime == null
                      ? "Select Meeting Time"
                      : "Meeting Time: ${_selectedTime!.format(context)}",
                  style: const TextStyle(fontSize: 16),
                ),
                CustomButton(
                  color: themecolor,
                  onTap: () {
                    _pickTime();
                  },
                  text: "Pick Time",
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Select Status:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedStatus,
              items: ["Approved"]
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Set Meeting",
              color: themecolor,
              onTap: _updateMeetingDetails, // Call update function
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick time
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _updateMeetingDetails() async {
    if (_selectedDate == null || _selectedTime == null) {
      ToastMessage().showToast("Please select both date and time");
      return;
    }

    String meetingTime =
        "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day} ${_selectedTime!.format(context)}";

    try {
      DocumentSnapshot jobSnapshot =
          await _firestore.collection("jobs").doc(widget.jobId).get();

      if (jobSnapshot.exists) {
        List<dynamic> appliedUsers = jobSnapshot["appliedUsers"];

        for (var user in appliedUsers) {
          if (user["userId"] == widget.userId) {
            user["status"] = _selectedStatus;
            user["meetingtime"] = meetingTime;
            break;
          }
        }

        await _firestore.collection("jobs").doc(widget.jobId).update({
          "appliedUsers": appliedUsers,
        });

        ToastMessage().showToast("Meeting updated successfully");
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const BottomScreenSh()));
      }
    } catch (e) {
      ToastMessage().showToast("Error $e");
    }
  }
}
