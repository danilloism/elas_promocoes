import 'package:elas_promocoes/core/const.dart';
import 'package:flutter/cupertino.dart';

extension IsMobile on BoxConstraints {
  bool get isMobile => maxWidth <= kMobileDeviceWidth;
}
