jQuery ->
	$ = jQuery
	# get all the pressable keys
	keys= $("#calculator span")
	cal_obj = {a:0,b:0}
	op_obj = {}
	operator = ""
	operator_counter = 0
	has_dot = false
	factor_divider = ['+','-','*','/']
	numbers = []
	operators=[]

	countDecimals = (value)->
		if (value % 1) != 0
			decimal_number = value.toString().split(".")[1].length
			if decimal_number > 8
				decimal_number = 8
			return decimal_number
		return 0

	parenthese_cal = (display_val)->
		while display_val.indexOf("+") or display_val.indexOf("-") or display_val.indexOf("*") or display_val.indexOf("/")
			console.log(display_val)
			operator_regex = /[^0-9.]+/g  #/[^0-9\\.]+/g
			# getting all the operators
			operators = display_val.match(operator_regex)
			regExp = /\(([^)]+)\)/
			matches = regExp.exec(display_val)
			parenthese_value = 0
			negative_inside = false
			if matches
				regExp = /\(([^)]+)\)/
				matches = regExp.exec(display_val)
				priority_operation = matches[0]
				left_value = priority_operation.replace("(","").replace(")","")
				num_regex =  /[\d\.]+/g #/(\d+)/g
				numbers = priority_operation.match(num_regex)
				operator_regex = /[^0-9.]+/g  #/[^0-9\\.]+/g
				# getting all the operators
				operators = left_value.match(operator_regex)

				temp_index = 0
				if left_value.indexOf("+") > -1 or left_value.indexOf("-") > -1 or left_value.indexOf("/") > -1 or left_value.indexOf("*") > -1
					# check if there is  * or / to change the operation order
					if ($.inArray('*', operators) == -1 and $.inArray('/', operators) == -1) or ($.inArray('+', operators) == -1 and $.inArray('-', operators) == -1)
						# only contains save level operators
						$.each(operators,(index)->
							number_index = index + temp_index
							a = numbers[number_index]
							b = numbers[number_index+1]
							a_decimal = countDecimals(a)
							b_decimal = countDecimals(b)
							decimal = if a_decimal>b_decimal then a_decimal else b_decimal
							if operators[index] == "+"
								temp = (parseFloat(a)+parseFloat(b)).toFixed(decimal)
							if operators[index] == "-"
								temp = (parseFloat(a)-parseFloat(b)).toFixed(decimal)
							if operators[index] == "*"
								temp = (parseFloat(a)*parseFloat(b)).toFixed(decimal)
							if operator =="/"
								temp = parseFloat(a)/parseFloat(b)
								console.log(temp)
								decimal_num = countDecimals(temp)
								if decimal_num > 5
									final_result = (parseFloat(a)/parseFloat(b)).toFixed(5)
								else
									final_result = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
							if numbers.length > 2
								numbers.splice(0,2)
								numbers.unshift(temp)
								temp_index -=1

							else
								final_result = temp
								left_value = final_result
						)
					else
						while operators.length >= 1
							$.each(operators,(index)->
								# first check if * exists
								if operators.indexOf("*") > -1 or operators.indexOf("/") > -1
									# check if current operator is *, if yes, then calculate, if not, move on to the next operator first
									if operators.indexOf("+") == index or operators.indexOf("-") == index
										console.log("skip this operator for now")
										return true
									else
										a = numbers[index]
										b = numbers[index+1]
										a_decimal = countDecimals(a)
										b_decimal = countDecimals(b)
										decimal = if a_decimal>b_decimal then a_decimal else b_decimal
										if operators[index] == "*"
											temp = parseFloat(a)*parseFloat(b).toFixed(decimal)
										if operators[index] == "/"
											temp = parseFloat(a)/parseFloat(b).toFixed(decimal)
										operators.splice(index, 1)
										if temp
											numbers[index] = temp
											numbers.splice(index+1,1)
								else
									a = numbers[index]
									b = numbers[index+1]
									if operators[index] == "+"
										temp = parseFloat(a)+parseFloat(b)
									if operators[index] == "-"
										temp = parseFloat(a)-parseFloat(b)
									operators.splice(index, 1)
									if temp
										numbers[index] = temp
										numbers.splice(index+1,1)

								if numbers.length == 1
									final_result = numbers[0]
									left_value = final_result
									if left_value < 0
										negative_inside = true
							)

				display_val = display_val.replace(priority_operation,left_value)

			else

				none_parentheses_cal(display_val)

				# display_val = final_result
				# $("#display_val").text(final_result)

	none_parentheses_cal = (left_value)->
		# getting all the numbers
		num_regex =  /[\d\.]+/g #/(\d+)/g
		numbers = left_value.match(num_regex)
		operator_regex = /[^0-9.]+/g  #/[^0-9\\.]+/g
		# getting all the operators
		operators = left_value.match(operator_regex)
		temp_index = 0
		if left_value.indexOf("+") > -1 or left_value.indexOf("-") > -1 or left_value.indexOf("/") > -1 or left_value.indexOf("*") > -1
			# check if there is  * or / to change the operation order
			if ($.inArray('*', operators) == -1 and $.inArray('/', operators) == -1) or ($.inArray('+', operators) == -1 and $.inArray('-', operators) == -1)
				# only contains save level operators
				$.each(operators,(index)->
					number_index = index + temp_index
					a = numbers[number_index]
					b = numbers[number_index+1]
					console.log(numbers)
					console.log(a)
					console.log(b)
					a_decimal = countDecimals(a)
					b_decimal = countDecimals(b)
					decimal = if a_decimal>b_decimal then a_decimal else b_decimal
					if operators[index] == "+"
						temp = (parseFloat(a)+parseFloat(b)).toFixed(decimal)
					if operators[index] == "-"
						temp = (parseFloat(a)-parseFloat(b)).toFixed(decimal)
					if operators[index] == "*"
						temp = (parseFloat(a)*parseFloat(b)).toFixed(decimal)
					if operators[index] =="/"
						temp = parseFloat(a)/parseFloat(b)
						console.log(temp)
						decimal_num = countDecimals(temp)
						if decimal_num > 5
							temp = temp.toFixed(5)
						else
							temp = temp.toFixed(decimal_num)
					if numbers.length > 2
						numbers.splice(0,2)
						numbers.unshift(temp)
						# console.log(numbers)
						temp_index -=1
						# console.log("temp index "+temp_index)
					else
						final_result = temp
						$("#display_val").text(final_result)
				)
			else
				while operators.length >= 1
					$.each(operators,(index)->
						# first check if * exists
						if operators.indexOf("*") > -1 or operators.indexOf("/") > -1
							# check if current operator is *, if yes, then calculate, if not, move on to the next operator first
							if operators.indexOf("+") == index or operators.indexOf("-") == index
								console.log("skip this operator for now")
								return true
							else
								a = numbers[index]
								b = numbers[index+1]
								a_decimal = countDecimals(a)
								b_decimal = countDecimals(b)
								decimal = if a_decimal>b_decimal then a_decimal else b_decimal
								if operators[index] == "*"
									temp = parseFloat(a)*parseFloat(b).toFixed(decimal)
								if operators[index] == "/"
									temp = parseFloat(a)/parseFloat(b).toFixed(decimal)
								operators.splice(index, 1)
								if temp
									numbers[index] = temp
									numbers.splice(index+1,1)
						else
							a = numbers[index]
							b = numbers[index+1]
							if operators[index] == "+"
								temp = parseFloat(a)+parseFloat(b)
							if operators[index] == "-"
								temp = parseFloat(a)-parseFloat(b)
							operators.splice(index, 1)
							if temp
								numbers[index] = temp
								numbers.splice(index+1,1)

						if numbers.length == 1
							final_result = numbers[0]
							$("#display_val").text(final_result)
					)



	# iterate through all the keys and add listener to them to decide which operation to take
	$.each(keys,(index, value)->
		$(this).on("click",->
			btn=$(this)
			display_val = $("#display_val").text()
			# to clear current data
			if btn.prop("id") == "clear"
					$("#display_val").text("")
					cal_obj = {a:0,b:0}
					operator = ""
					has_dot = false
					numbers = []
					operators=[]
					operator_counter = 0
			else
				if btn.prop("id") == "equal"
					if  operator_counter >= 2
						#complex operation

						# if there is parenthese then respect the ()
						if display_val.indexOf("(")>-1 and display_val.indexOf(")")>-1
							parenthese_cal(display_val)

						# if no () then respect the regular opertaion priority
						else
							none_parentheses_cal(display_val)

					else
						# single operation
						cal_obj.b = $("#display_val").text().replace(cal_obj.a+operator,"")
						a_decimal = countDecimals(cal_obj.a)
						b_decimal = countDecimals(cal_obj.b)
						# based on the decimals of two factors, decide which decimal should be applied to the final result
						decimal = if a_decimal>b_decimal then a_decimal else b_decimal
						# the actual calculate part
						if operator == "+"
							final_result = (parseFloat(cal_obj.a)+parseFloat(cal_obj.b)).toFixed(decimal)
						if operator =="-"
							final_result = (parseFloat(cal_obj.a)-parseFloat(cal_obj.b)).toFixed(decimal)
						if operator =="*"
							final_result = (parseFloat(cal_obj.a)*parseFloat(cal_obj.b)).toFixed(decimal)
						if operator =="/"
							temp = parseFloat(cal_obj.a)/parseFloat(cal_obj.b)
							console.log(temp)
							decimal_num = countDecimals(temp)
							if decimal_num > 5
								final_result = (parseFloat(cal_obj.a)/parseFloat(cal_obj.b)).toFixed(5)
							else
								final_result = (parseFloat(cal_obj.a)/parseFloat(cal_obj.b)).toFixed(decimal_num)
					$("#display_val").text(final_result)
				else

					# input part

					# if dot is already in the number then disable any more dots, but if there is operator after one number then dot is allow for the second number
					last_char = display_val[display_val.length-1]
					if factor_divider.indexOf(last_char) > -1
						factor = display_val.substring(0, display_val.length - 1);
						if factor.indexOf(".")>-1
							has_dot= false
					if btn.hasClass("operator")
						operator_counter += 1
						cal_obj.a = display_val
						operator = btn.text()
					if btn.prop("id") == "dot"
						#only allow dot when there is none in the data, otherwise, skip it
						if not has_dot
							display_val += btn.text()
							has_dot = true
					else
						# forbid multiple 0 at the beginning of the value
						if not(last_char == "0" && btn.text() == "0" and display_val.length == 1)
							display_val += btn.text()
					$("#display_val").text(display_val)


		)
	)