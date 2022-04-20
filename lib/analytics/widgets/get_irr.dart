import 'dart:math';

num internal_rate_of_return(List<num> flow, num investment, num guess) {
  num irr = guess;
  num increment;
  Function irrCalc;

  if (net_present_value(flow, investment, irr) >
      net_present_value(flow, investment, irr + 1.1)) {
    increment = 1;
    irrCalc = _pos_irr_calc;
  } else {
    increment = -1;
    irrCalc = _neg_irr_calc;
  }

  // max for iterations is 18
  for (int x = 0; x < 10; x += 1) {
    increment /= 10;
    irr = irrCalc(flow, investment, irr, increment);
  }

  irr += increment;
  irr *= 100;
  return round(irr, 4);
}

num _pos_irr_calc(List<num> flow, num investment, num start, num increment) {
  num irr;
  num npv;

  for (irr = start; irr < 1.0; irr += increment) {
    npv = net_present_value(flow, investment, irr);
    if (npv < 0) {
      break;
    }
  }
  irr -= increment;
  return irr;
}

num _neg_irr_calc(List<num> flow, num investment, num start, num increment) {
  num irr;
  num npv;

  for (irr = start; irr > -1.0; irr += increment) {
    npv = net_present_value(flow, investment, irr);
    if (npv > 0) {
      break;
    }
  }
  irr -= increment;
  return irr;
}

num net_present_value(List<num> flow, num investment, num irr) {
  num pv;
  int i;
  num divisor;
  int length = flow.length;

  pv = 0.0;
  for (i = 0; i < length; i++) {
    divisor = pow((1.0 + irr), (i + 1));
    pv = pv + (flow[i] / divisor);
  }
  return pv - investment;
}

num round(num number, [num ndigit = 0]) {
  if (ndigit == 0) return number.round();

  num dig = pow(10, ndigit);
  return ((number * dig).round() / dig);
}