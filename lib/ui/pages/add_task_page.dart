import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/tsk_cntrlr.dart';
import 'package:todo/models/tsk.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _slctdDt = DateTime.now();
  String _strtTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _slctdrmind = 5;
  List<int> rmindLst = [1, 5, 10, 15, 20];
  String _slctdrepeat = 'None';
  List<String> repeatLst = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _slctClr = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Add Task', style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter Title Here',
                cntrlr: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Note Here',
                cntrlr: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_slctdDt),
                wdgt: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => _getDateFromUser(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _strtTime,
                      wdgt: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      wdgt: IconButton(
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: 'Remind',
                hint: '$_slctdrmind minutes early',
                wdgt: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      iconEnabledColor: const Color.fromARGB(255, 55, 66, 71),
                      iconDisabledColor:
                          const Color.fromARGB(255, 126, 146, 156),
                      borderRadius: BorderRadius.circular(10),
                      items: rmindLst
                          .map<DropdownMenuItem<String>>(
                            (int val) => DropdownMenuItem<String>(
                              value: val.toString(),
                              child: Text(
                                '$val',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: subTitleStyle,
                      onChanged: (String? nval) {
                        setState(() {
                          _slctdrmind = int.parse(nval!);
                        });
                      },
                    ),
                    const SizedBox(width: 7),
                  ],
                ),
              ),
              InputField(
                title: 'Repeat',
                hint: _slctdrepeat,
                wdgt: Row(
                  children: [
                    DropdownButton(
                      dropdownColor: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                      items: repeatLst
                          .map<DropdownMenuItem<String>>(
                            (String val) => DropdownMenuItem<String>(
                              value: val,
                              child: Text(
                                val,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      underline: Container(height: 0),
                      style: subTitleStyle,
                      onChanged: (String? nval) {
                        setState(() {
                          _slctdrepeat = nval!;
                        });
                      },
                    ),
                    const SizedBox(width: 7),
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _creatClr(),
                  MyButton(
                      labl: 'Create Task',
                      onTap: () {
                        _validateDate();
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 24,
            color: primaryClr,
          ),
        ),
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(width: 20),
        ],
      );

  Column _creatClr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int idx) => GestureDetector(
              onTap: () {
                setState(() {
                  _slctClr = idx;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: (_slctClr == idx)
                      ? const Icon(
                          Icons.done_all_outlined,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                  backgroundColor: (idx == 0)
                      ? primaryClr
                      : (idx == 1)
                          ? pinkClr
                          : orangeClr,
                  radius: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        'Required',
        'All fieldes are required!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_outlined, color: Colors.red),
      );
    } else
      print('Something Bad Happend');
  }

  _addTaskToDB() async {
    int val = await _taskController.addTask(
      tsk: Task(
        title: _titleController.text,
        note: _noteController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_slctdDt),
        startTime: _strtTime,
        endTime: _endTime,
        color: _slctClr,
        remind: _slctdrmind,
        repeat: _slctdrepeat,
      ),
    );
    print('$val');
  }

  _getDateFromUser() async {
    DateTime? _pickdDate = await showDatePicker(
      context: context,
      initialDate: _slctdDt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: darkGreyClr,
            onPrimary: Colors.grey,
            surface: primaryClr,
            onSurface: darkGreyClr,
          ),
        ),
        child: child!,
      ),
    );
    if (_pickdDate != null)
      setState(() => _slctdDt = _pickdDate);
    else
      print('It\'s null or Something is Wrong');
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? _pickdTime = await showTimePicker(
      //initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
      builder: (context, child) => Theme(
        data: ThemeData().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: darkGreyClr,
            onPrimary: Colors.grey,
            surface: Colors.white,
            onSurface: primaryClr,
          ),
        ),
        child: child!,
      ),
    );
    String _formatedTime = _pickdTime!.format(context);
    if (isStartTime)
      setState(() => _strtTime = _formatedTime);
    else if (!isStartTime)
      setState(() => _endTime = _formatedTime);
    else
      print('Time Cenceld');
  }
}
