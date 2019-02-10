import 'package:git_point/src/api/index.dart';

// https://github.com/timqian/star-history/blob/gh-pages/src/getStarHistory.js#L4
// ['ee3a172df9aaa8c858b5585ca53391cec47b20c0', 'da9f64e669b91d89f5abe19b313ab07a54b7c974', '31eee536d05b169b3e184e152d18775f7166123b', '9da45c0ed04c77c47278bb260d7c6b6c2c9b9fa8', 'd96ed1e68bec80e725db8f23327a96839def67a6', '569e1881d1b810c39e35c650f056ea6fac05a400'];
const accessToken = 'd96ed1e68bec80e725db8f23327a96839def67a6';

main(List<String> args) {
  v3.get('/user', accessToken).then((value) {print(value.body);});
}