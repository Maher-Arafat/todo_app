import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/tsk_cntrlr.dart';
import 'package:todo/models/tsk.dart';
import 'package:todo/services/notfction_srvcs.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    //notifyHelper.requestAndroidPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTask();
  }

  DateTime _slctdDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.purple, primaryClr])),
              child: Text(
                'Schedualing Time',
                style: TextStyle(fontSize: 30),
              ),
            ),
            ListTile(
              leading: Icon(
                Get.isDarkMode
                    ? Icons.wb_sunny_rounded
                    : Icons.nightlight_round_outlined,
                size: 24,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
              title: const Text('Switch Theme', style: TextStyle(fontSize: 24)),
              onTap: ThemeServices().swthTheme,
            ),
            const Divider(thickness: 2),
            ListTile(
              leading: Icon(
                Icons.cleaning_services_rounded,
                size: 24,
                color: Get.isDarkMode ? Colors.white : darkGreyClr,
              ),
              title: const Text(
                'Delete All Task',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              onTap: () {
                notifyHelper.cencelAllNotification();
                _taskController.deleteAllTask();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryClr.withOpacity(0.95),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('images/person.jpeg'),
            radius: 18,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          _addTaskbar(),
          _addDatebar(),
          const SizedBox(height: 5),
          _showTask(),
        ],
      ),
    );
  }

  // ignore: unused_element
  AppBar _buildAppBar() {
    return AppBar(
      /* leading: IconButton(
        onPressed: () {
          ThemeServices().swthTheme();
          //notifyHelper.displayNotification(
          //title: 'Theme Changed',
          //body: 'efijneceirn',
          //);
          //notifyHelper.schedualeNotification();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_rounded
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),*/
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      actions: const [
        /*IconButton(
          onPressed: () {
            notifyHelper.cencelAllNotification();
            _taskController.deleteAllTask();
          },
          icon: Icon(
            Icons.cleaning_services_rounded,
            size: 24,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
        ),
       */
        CircleAvatar(
          backgroundImage: AssetImage('images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _addTaskbar() {
    return Container(
      //padding: const EdgeInsets.only(right: 4),
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text('Today', style: headingStyle),
            ],
          ),
          MyButton(
              labl: 'Add Task',
              onTap: () async {
                await Get.to(() => const AddTaskPage());
                _taskController.getTask();
              }),
        ],
      ),
    );
  }

  _addDatebar() {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 20),
      child: DatePicker(
        DateTime.now(),
        width: 70,
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        )),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        )),
        onDateChange: (nDate) {
          setState(() {
            _slctdDate = nDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _taskController.getTask();
  }

  _showTask() {
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTskMsg();
          } else
            return RefreshIndicator(
              color: primaryClr,
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext ctx, int idx) {
                  var tsk = _taskController.taskList[idx];
                  if ((tsk.repeat == 'Daily' &&
                          (tsk.date == DateFormat.yMd().format(_slctdDate) ||
                              _slctdDate.isAfter(DateTime.now()))) ||
                      (tsk.repeat == 'Weekly' &&
                          _slctdDate
                                      .difference(
                                          DateFormat.yMd().parse(tsk.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      (tsk.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(tsk.date!).day ==
                              _slctdDate.day)) {
                    var date = DateFormat.jm().parse(tsk.startTime!);
                    var time = DateFormat('HH:mm').format(date);
                    notifyHelper.scheduledNotification(
                      int.parse(time.toString().split(':')[0]),
                      int.parse(time.toString().split(':')[1]),
                      tsk,
                    );
                    return AnimationConfiguration.staggeredList(
                      position: idx,
                      duration: const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => showBottomSheet(context, tsk),
                            child: TaskTile(tsk),
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container();
                },
                itemCount: _taskController.taskList.length,
              ),
            );
        },
      ),
    );
  }

  _noTskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 2),
          child: RefreshIndicator(
            color: primaryClr,
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    color: primaryClr.withOpacity(.6),
                    height: 100,
                    semanticsLabel: 'Task',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'You don`t have any tasks yet!\nAdd new tasks to make your days productive.',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  showBottomSheet(BuildContext ctx, Task tsk) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (tsk.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (tsk.isCompleted == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),
            tsk.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Task Completed',
                    onTap: () {
                      notifyHelper.cencelNotification(tsk);
                      _taskController.changTask(tsk.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                  ),
            _buildBottomSheet(
              label: 'Delete Task',
              onTap: () {
                notifyHelper.cencelNotification(tsk);
                _taskController.deleteTask(tsk);
                Get.back();
              },
              clr: Colors.red[300]!,
            ),
            Divider(
                color: Get.isDarkMode ? Colors.grey : darkGreyClr,
                thickness: 1),
            _buildBottomSheet(
              label: 'Cencel',
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 45,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[500]!
                  : clr),
          borderRadius: BorderRadius.circular(15),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
