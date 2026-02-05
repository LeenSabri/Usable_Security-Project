import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_drawer.dart';
import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime selectedDate = DateTime.now();

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Select Month & Year",
            style: TextStyle(color: AppColors.primaryBlue, fontSize: 18),
          ),
          content: SizedBox(
            width: 320,
            height: 350,
            child: CustomMonthYearPicker(
              initialDate: selectedDate,
              onDateSelected: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM, yyyy').format(selectedDate);

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      drawer: const CustomDrawer(),
      appBar: CustomAppBar(title: "Reports"),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cars",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              _buildLegend(),
              const SizedBox(height: 20),
              _buildPieChart(),
              const SizedBox(height: 30),

              const Text(
                "Profits",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              _buildCalendarPicker(context, formattedDate),
              const SizedBox(height: 10),
              _buildProfitCard(),

              const SizedBox(height: 30),

              const Text(
                "Booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              _buildCalendarPicker(context, formattedDate),
              const SizedBox(height: 15),
              _buildBookingStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarPicker(BuildContext context, String dateLabel) {
    return InkWell(
      onTap: () => _showMonthYearPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem("Booked", const Color(0xFF3E829A)),
        _legendItem("In maintenance", const Color(0xFF0D3B73)),
        _legendItem("Available", const Color(0xFF7694BC)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 0,
          sections: [
            PieChartSectionData(
              color: const Color(0xFF3E829A),
              value: 20,
              radius: 80,
              showTitle: false,
            ),
            PieChartSectionData(
              color: const Color(0xFF0D3B73),
              value: 35,
              radius: 80,
              showTitle: false,
            ),
            PieChartSectionData(
              color: const Color(0xFF7694BC),
              value: 45,
              radius: 80,
              showTitle: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfitCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statColumn("Total Profit", "\$ 1000"),
          Container(width: 1, height: 40, color: AppColors.primaryBlue),
          _statColumn("Rented cars", "20"),
        ],
      ),
    );
  }

  Widget _statColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(color: AppColors.primaryBlue, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildBookingStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _bookingBox("Accepted", "20", const Color(0xFF4B90A6)),
        _bookingBox("Canceled", "4", const Color(0xFF0D3B73)),
        _bookingBox("Requested", "5", const Color(0xFF7694BC)),
      ],
    );
  }

  Widget _bookingBox(String label, String count, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomMonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomMonthYearPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomMonthYearPicker> createState() => _CustomMonthYearPickerState();
}

class _CustomMonthYearPickerState extends State<CustomMonthYearPicker> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 16),
              onPressed: () => setState(() => selectedYear--),
            ),
            Text(
              "$selectedYear",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: selectedYear < DateTime.now().year
                  ? () => setState(() => selectedYear++)
                  : null,
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            itemCount: 12,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
            ),
            itemBuilder: (context, index) {
              int month = index + 1;
              DateTime monthDate = DateTime(selectedYear, month);
              bool isFuture = monthDate.isAfter(DateTime.now());
              bool isSelected = selectedMonth == month;

              return InkWell(
                onTap: isFuture
                    ? null
                    : () {
                        setState(() => selectedMonth = month);
                        widget.onDateSelected(
                          DateTime(selectedYear, selectedMonth),
                        );
                      },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : (isFuture ? Colors.grey[100] : Colors.white),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('MMM').format(monthDate),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (isFuture ? Colors.grey : AppColors.primaryBlue),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
