enum AppointmentStatus {
  scheduled,
  confirmed,
  arrived,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled, // تمت إضافة الحالة المقترحة للتعامل مع "إعادة الجدولة" بدلاً من الرفض
}
