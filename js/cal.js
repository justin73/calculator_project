// Generated by CoffeeScript 1.10.0
(function() {
  jQuery(function() {
    var $, basic_cal, countDecimals, factor_divider, has_dot, keys, none_parentheses_cal, numbers, operator, operator_counter, operators, parenthese_cal;
    $ = jQuery;
    keys = $("#calculator span");
    operator = "";
    operator_counter = 0;
    has_dot = false;
    factor_divider = ['+', '-', '*', '/'];
    numbers = [];
    operators = [];
    $("#display_val").on("keypress", function(e) {
      var valid_keys;
      valid_keys = [13, 42, 46, 63, 43, 95, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
      if (valid_keys.indexOf(e.keyCode) === -1) {
        return false;
      }
      if (e.keyCode === 13) {
        $("#equal").trigger("click");
      }
      return true;
    });
    countDecimals = function(value) {
      var decimal_number;
      if ((value % 1) !== 0) {
        decimal_number = value.toString().split(".")[1].length;
        if (decimal_number > 8) {
          decimal_number = 8;
        }
        return decimal_number;
      }
      return 0;
    };
    basic_cal = function(a, b) {
      var a_decimal, b_decimal, decimal, decimal_num, final_result, temp;
      a_decimal = countDecimals(a);
      b_decimal = countDecimals(b);
      decimal = a_decimal > b_decimal ? a_decimal : b_decimal;
      if (operator === "+") {
        final_result = (parseFloat(a) + parseFloat(b)).toFixed(decimal);
      }
      if (operator === "-") {
        final_result = (parseFloat(a) - parseFloat(b)).toFixed(decimal);
      }
      if (operator === "*") {
        final_result = (parseFloat(a) * parseFloat(b)).toFixed(decimal);
      }
      if (operator === "/") {
        temp = parseFloat(a) / parseFloat(b);
        console.log(temp);
        decimal_num = countDecimals(temp);
        if (decimal_num > 5) {
          final_result = (parseFloat(a) / parseFloat(b)).toFixed(5);
        } else {
          final_result = (parseFloat(a) / parseFloat(b)).toFixed(decimal_num);
        }
      }
      return final_result;
    };
    parenthese_cal = function(display_val) {
      var left_value, matches, negative_inside, num_regex, operator_regex, parenthese_value, priority_operation, regExp, temp_index;
      while (display_val.indexOf("+") > -1 || display_val.indexOf("-") > -1 || display_val.indexOf("*") > -1 || display_val.indexOf("/") > -1) {
        operator_regex = /[^0-9.]+/g;
        operators = display_val.match(operator_regex);
        regExp = /\(([^)]+)\)/;
        matches = regExp.exec(display_val);
        parenthese_value = 0;
        negative_inside = false;
        if (matches) {
          regExp = /\(([^)]+)\)/;
          matches = regExp.exec(display_val);
          priority_operation = matches[0];
          left_value = priority_operation.replace("(", "").replace(")", "");
          num_regex = /[\d\.]+/g;
          numbers = priority_operation.match(num_regex);
          operator_regex = /[^0-9.]+/g;
          operators = left_value.match(operator_regex);
          temp_index = 0;
          if (left_value.indexOf("+") > -1 || left_value.indexOf("-") > -1 || left_value.indexOf("/") > -1 || left_value.indexOf("*") > -1) {
            if (($.inArray('*', operators) === -1 && $.inArray('/', operators) === -1) || ($.inArray('+', operators) === -1 && $.inArray('-', operators) === -1)) {
              $.each(operators, function(index) {
                var a, b, final_result, number_index, temp;
                number_index = index + temp_index;
                a = numbers[number_index];
                b = numbers[number_index + 1];
                temp = basic_cal(a, b);
                if (numbers.length > 2) {
                  numbers.splice(0, 2);
                  numbers.unshift(temp);
                  return temp_index -= 1;
                } else {
                  final_result = temp;
                  return left_value = final_result;
                }
              });
            } else {
              while (operators.length >= 1) {
                $.each(operators, function(index) {
                  var a, a_decimal, b, b_decimal, decimal, final_result, temp;
                  if (operators.indexOf("*") > -1 || operators.indexOf("/") > -1) {
                    if (operators.indexOf("+") === index || operators.indexOf("-") === index) {
                      console.log("skip this operator for now");
                      return true;
                    } else {
                      a = numbers[index];
                      b = numbers[index + 1];
                      a_decimal = countDecimals(a);
                      b_decimal = countDecimals(b);
                      decimal = a_decimal > b_decimal ? a_decimal : b_decimal;
                      if (operators[index] === "*") {
                        temp = parseFloat(a) * parseFloat(b).toFixed(decimal);
                      }
                      if (operators[index] === "/") {
                        temp = parseFloat(a) / parseFloat(b).toFixed(decimal);
                      }
                      operators.splice(index, 1);
                      if (temp) {
                        numbers[index] = temp;
                        numbers.splice(index + 1, 1);
                      }
                    }
                  } else {
                    a = numbers[index];
                    b = numbers[index + 1];
                    if (operators[index] === "+") {
                      temp = parseFloat(a) + parseFloat(b);
                    }
                    if (operators[index] === "-") {
                      temp = parseFloat(a) - parseFloat(b);
                    }
                    operators.splice(index, 1);
                    if (temp) {
                      numbers[index] = temp;
                      numbers.splice(index + 1, 1);
                    }
                  }
                  if (numbers.length === 1) {
                    final_result = numbers[0];
                    left_value = final_result;
                    if (left_value < 0) {
                      return negative_inside = true;
                    }
                  }
                });
              }
            }
          }
          display_val = display_val.replace(priority_operation, left_value);
          console.log("value inside () is " + left_value);
          continue;
        } else {
          num_regex = /[\d\.]+/g;
          numbers = display_val.match(num_regex);
          operator_regex = /[^0-9.]+/g;
          operators = display_val.match(operator_regex);
          if (numbers.length === 1 && operators.length === 1 && operators[0] === "-") {
            display_val = display_val.toString();
            break;
          } else {
            display_val = none_parentheses_cal(display_val);
            display_val = display_val.toString();
          }
          continue;
        }
      }
      return display_val;
    };
    none_parentheses_cal = function(left_value) {
      var final_result, num_regex, operator_regex, temp_index;
      num_regex = /[\d\.]+/g;
      numbers = left_value.match(num_regex);
      operator_regex = /[^0-9.]+/g;
      operators = left_value.match(operator_regex);
      temp_index = 0;
      final_result = 0;
      if (left_value.indexOf("+") > -1 || left_value.indexOf("-") > -1 || left_value.indexOf("/") > -1 || left_value.indexOf("*") > -1) {
        if (($.inArray('*', operators) === -1 && $.inArray('/', operators) === -1) || ($.inArray('+', operators) === -1 && $.inArray('-', operators) === -1)) {
          $.each(operators, function(index) {
            var a, b, number_index, temp;
            number_index = index + temp_index;
            a = numbers[number_index];
            b = numbers[number_index + 1];
            temp = basic_cal(a, b);
            if (numbers.length > 2) {
              numbers.splice(0, 2);
              numbers.unshift(temp);
              return temp_index -= 1;
            } else {
              return final_result = temp;
            }
          });
        } else {
          while (operators.length >= 1) {
            $.each(operators, function(index) {
              var a, a_decimal, b, b_decimal, decimal, temp;
              if (operators.indexOf("*") > -1 || operators.indexOf("/") > -1) {
                if (operators.indexOf("+") === index || operators.indexOf("-") === index) {
                  console.log("skip this operator for now");
                  return true;
                } else {
                  a = numbers[index];
                  b = numbers[index + 1];
                  a_decimal = countDecimals(a);
                  b_decimal = countDecimals(b);
                  decimal = a_decimal > b_decimal ? a_decimal : b_decimal;
                  if (operators[index] === "*") {
                    temp = parseFloat(a) * parseFloat(b).toFixed(decimal);
                  }
                  if (operators[index] === "/") {
                    temp = parseFloat(a) / parseFloat(b).toFixed(decimal);
                    console.log(temp);
                  }
                  operators.splice(index, 1);
                  if (temp) {
                    numbers[index] = temp;
                    numbers.splice(index + 1, 1);
                  }
                }
              } else {
                a = numbers[index];
                b = numbers[index + 1];
                if (operators[index] === "+") {
                  temp = parseFloat(a) + parseFloat(b);
                }
                if (operators[index] === "-") {
                  temp = parseFloat(a) - parseFloat(b);
                }
                operators.splice(index, 1);
                if (temp) {
                  numbers[index] = temp;
                  numbers.splice(index + 1, 1);
                }
              }
              if (numbers.length === 1) {
                return final_result = numbers[0];
              } else {
                return false;
              }
            });
          }
        }
      }
      return final_result;
    };
    $.each(keys, function(index, value) {
      return $(this).on("click", function() {
        var btn, display_val, factor, final_result, last_char;
        btn = $(this);
        display_val = $("#display_val").val();
        if (btn.prop("id") === "clear") {
          $("#display_val").val("");
          operator = "";
          has_dot = false;
          numbers = [];
          operators = [];
          return operator_counter = 0;
        } else {
          if (btn.prop("id") === "equal") {
            if (operator_counter >= 2) {
              if (display_val.indexOf("(") > -1 && display_val.indexOf(")") > -1) {
                final_result = parenthese_cal(display_val);
              } else {
                final_result = none_parentheses_cal(display_val);
              }
            } else {
              final_result = none_parentheses_cal(display_val);
            }
            return $("#display_val").val(final_result);
          } else {
            last_char = display_val[display_val.length - 1];
            if (factor_divider.indexOf(last_char) > -1) {
              factor = display_val.substring(0, display_val.length - 1);
              if (factor.indexOf(".") > -1) {
                has_dot = false;
              }
            }
            if (btn.hasClass("operator")) {
              if (display_val.length >= 1) {
                operator_counter += 1;
                operator = btn.text();
                if (factor_divider.indexOf(last_char) > -1) {
                  display_val = display_val.slice(0, -1);
                }
              }
            }
            if (btn.prop("id") === "dot") {
              if (!has_dot) {
                display_val += btn.text();
                has_dot = true;
              }
            } else {
              if (!(last_char === "0" && btn.text() === "0" && display_val.length === 1) && !(display_val.length === 0 && btn.hasClass("operator"))) {
                display_val += btn.text();
                console.log(display_val);
              }
            }
            return $("#display_val").val(display_val);
          }
        }
      });
    });
    return $("#equal").on("click", function() {});
  });

}).call(this);
