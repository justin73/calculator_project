jQuery ->
	$ = jQuery
	# get all the pressable keys
	keys= $("#calculator span")
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

	# remove_comma = (value)->
	# 	new_value = value.replace(",","")
	# 	return new_value
	# add_comma = (value)->
	# 	is_integer = /^\d+$/.test(value)
	# 	# if it is integer, then add comma after every three digits
	# 	if is_integer
	# 		value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
	# 		return value
	# 	# if it is decimal, only add comma after every three digits before the dot
	# 	else
	# 		integer_part = value.split(".")[0]
	# 		decimal_part = value.split(".")[1]
	# 		integer_value = integer_part.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
	# 		value = integer_value+decimal_part
	# 		return value

	basic_cal = (a,b)->
		# a_decimal = countDecimals(a)
		# b_decimal = countDecimals(b)
		# # based on the decimals of two factors, decide which decimal should be applied to the final result
		# decimal = if a_decimal>b_decimal then a_decimal else b_decimal
		# the actual calculate part
		if operator == "+"
			final_result = (parseFloat(a)+parseFloat(b)).toFixed(decimal)
		if operator =="-"
			final_result = (parseFloat(a)-parseFloat(b)).toFixed(decimal)
		if operator =="*"
			final_result = (parseFloat(a)*parseFloat(b)).toFixed(decimal)
		if operator =="/"
			temp = parseFloat(a)/parseFloat(b)
			console.log(temp)
			decimal_num = countDecimals(temp)
			if decimal_num > 5
				final_result = (parseFloat(a)/parseFloat(b)).toFixed(5)
			else
				final_result = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
		return final_result

	parenthese_cal = (display_val)->
		while display_val.indexOf("+") or display_val.indexOf("-") or display_val.indexOf("*") or display_val.indexOf("/")
			regExp = /\(([^)]+)\)/
			matches = regExp.exec(display_val)
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
							# temp = basic_cal(a,b)
							a_decimal = countDecimals(a)
							b_decimal = countDecimals(b)
							decimal = if a_decimal>b_decimal then a_decimal else b_decimal
							if operators[index] == "+"
								temp = (parseFloat(a)+parseFloat(b)).toFixed(decimal)
							if operators[index] == "-"
								temp = (parseFloat(a)-parseFloat(b)).toFixed(decimal)
							if operators[index] == "*"
								temp = (parseFloat(a)*parseFloat(b)).toFixed(decimal)
							if operators[index] == "/"
								temp = parseFloat(a)/parseFloat(b)
								console.log(temp)
								decimal_num = countDecimals(temp)
								if decimal_num > 5
									temp = (parseFloat(a)/parseFloat(b)).toFixed(5)
								else
									temp = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
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
											temp = parseFloat(a)/parseFloat(b)
											console.log(temp)
											decimal_num = countDecimals(temp)
											if decimal_num > 5
												temp = (parseFloat(a)/parseFloat(b)).toFixed(5)
											else
												temp = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
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
							)

				display_val = display_val.replace(priority_operation,left_value)

			else
				none_parentheses_cal(display_val)
				display_val = final_result

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
					# temp = basic_cal(a,b)
					a_decimal = countDecimals(a)
					b_decimal = countDecimals(b)
					decimal = if a_decimal>b_decimal then a_decimal else b_decimal
					if operators[index] == "+"
						temp = (parseFloat(a)+parseFloat(b)).toFixed(decimal)
					if operators[index] == "-"
						temp = (parseFloat(a)-parseFloat(b)).toFixed(decimal)
					if operators[index] == "*"
						temp = (parseFloat(a)*parseFloat(b)).toFixed(decimal)
					if operators[index] == "/"
						temp = parseFloat(a)/parseFloat(b)
						console.log(temp)
						decimal_num = countDecimals(temp)
						if decimal_num > 5
							temp = (parseFloat(a)/parseFloat(b)).toFixed(5)
						else
							temp = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
					if numbers.length > 2
						numbers.splice(0,2)
						numbers.unshift(temp)
						# console.log(numbers)
						temp_index -=1
						# console.log("temp index "+temp_index)
					else
						final_result = temp

					# final_result = add_comma(final_result)
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
									temp = parseFloat(a)/parseFloat(b)
									console.log(temp)
									decimal_num = countDecimals(temp)
									if decimal_num > 5
										temp = (parseFloat(a)/parseFloat(b)).toFixed(5)
									else
										temp = (parseFloat(a)/parseFloat(b)).toFixed(decimal_num)
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
							# final_result = add_comma(final_result)
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
					operator = ""
					has_dot = false
					numbers = []
					operators=[]
					operator_counter = 0
			else
				if btn.prop("id") == "equal"
					if  operator_counter >= 2
						#complex operation
						if display_val.indexOf("(")>-1 and display_val.indexOf(")")>-1
							# display_val = remove_comma(display_val)
							parenthese_cal(display_val)
						else
							# display_val = remove_comma(display_val)
							none_parentheses_cal(display_val)
					else
						# single operation
						# display_val = remove_comma(display_val)
						none_parentheses_cal(display_val)
				else
					if display_val.indexOf(",") > -1
						last_comma_position = display_val.lastIndexOf(",")
						# display_val = remove_comma(display_val)
						str_length = display_val.length
						a = str_length - 3
						num_comma= 0
						while a >= 1
							num_comma +=1
							a = a - 3
						if num_comma
							append_comma = true
					else
						if display_val.length == 3
							append_comma = /^\d+$/.test(display_val)
						if display_val.length > 3
							last_three_char = display_val.substr(display_val.length-3);
							console.log(last_three_char)
							append_comma = /^\d+$/.test(last_three_char)
							console.log(append_comma)

					# input part
					# if dot is already in the number then disable any more dots, but if there is operator after one number then dot is allow for the second number
					last_char = display_val[display_val.length-1]
					if factor_divider.indexOf(last_char) > -1
						factor = display_val.substring(0, display_val.length - 1);
						if factor.indexOf(".")>-1
							has_dot= false
					if btn.hasClass("operator")
						append_comma = false
						operator_counter += 1
						operator = btn.text()
						# replace the operator when the last char is already an operator so that no multiple operators will be allowed
						if factor_divider.indexOf(last_char) > -1
							display_val = display_val.slice(0,-1)
					if btn.prop("id") == "dot"
						append_comma = false
						#only allow dot when there is none in the data, otherwise, skip it
						if not has_dot
							display_val += btn.text()
							has_dot = true
					else

						# forbid multiple 0 at the beginning of the value
						if not(last_char == "0" && btn.text() == "0" and display_val.length == 1)
							display_val += btn.text()
					# 		if append_comma
					# 			a = display_val.length-3
					# 			console.log(a)
					# 			next_comma = 1
					# 			move = 0
					# 			while a > 0
					# 				display_val = display_val.slice(0, 3*next_comma+move) + "," + display_val.slice(3*next_comma+move)
					# 				a -=3
					# 				next_comma +=1
					# 				move +=1
					# 				# last_three_char = display_val.substr(display_val.length-3);
					# 				# display_val = display_val.substr(0,display_val.length-3)+","+last_three_char

					# append_comma = false
					$("#display_val").text(display_val)

		)
	)