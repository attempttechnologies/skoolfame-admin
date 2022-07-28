import 'package:intl/intl.dart';

class DateFormatter {
  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now().toLocal();

    DateTime localDateTime = dateTime.toLocal();

    if (localDateTime.difference(now).inDays == 0) {
      var differenceInHours = localDateTime.difference(now).inHours.abs();
      var differenceInMins = localDateTime.difference(now).inMinutes.abs();

      if (differenceInHours > 0) {
        return '$differenceInHours hours ago';
      } else if (differenceInMins > 2) {
        return '$differenceInMins mins ago';
      } else {
        return 'Just now';
      }
    }

    String roughTimeString = DateFormat('jm').format(dateTime.toLocal());
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      print('RoughTime String :: :: $roughTimeString');

      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return 'Yesterday';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat(
        'EEEE',
      ).format(localDateTime.toLocal());

      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd').format(dateTime.toLocal())}, $roughTimeString';
  }
}

//DateFormatter().getVerboseDateTimeRepresentation(
//             DateTime.parse('2022-07-15T09:48:38.637Z'),
//           );
