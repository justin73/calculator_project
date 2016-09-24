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
	is_negative = false

	$( "#display_val" ).on("keypress", (e)->
		valid_keys= [13,40,41,42,45,46,47,63,43,95,48,49,50,51,52,53,54,55,56,57]
		if valid_keys.indexOf(e.keyCode) == -1
			return false
		if e.keyCode == 13
			enter_to_calculate()
		return true
	)
	get_operators = (value)->
		operator_regex = /[^0-9.]+/g  #/[^0-9\\.]+/g
		# getting all the operators
		operators = value.match(operator_regex)
		return operators

	get_numbers = (value)->
		num_regex =  /[\d\.]+/g #/(\d+)/g
		numbers = value.match(num_regex)

	handle_neg_value = (display_val,neg_operators)->
		first = neg_operators.charAt(0)
		negative_index = display_val.indexOf(neg_operators)
		temp_display_val = display_val.replace(neg_operators,"")
		if temp_display_val.indexOf("+") == -1 and temp_display_val.indexOf("+") == -1
			display_val = display_val.replace(neg_operators,first)
			is_negative = true
			display_val = display_val
		else
			console.log("plus position:" + display_val.indexOf("+"))
			console.log("*- position:" + display_val.indexOf(neg_operators))
			if display_val.indexOf(neg_operators)> -1 and display_val.indexOf("+")> -1
				if display_val.indexOf("+") < display_val.indexOf(neg_operators)
					display_val = display_val.replace(neg_operators,first)
					temp =display_val.slice(display_val.indexOf("+"))
					display_val_remaining = temp.slice(1)
					display_val = display_val.slice(0,display_val.indexOf("+"))+"+0-"+display_val_remaining
					console.log("there is a plus ahead"  + display_val)
				else
					display_val = display_val.replace(neg_operators,first)
					display_val = "0-"+display_val
					console.log("there is no plus ahead" + display_val)
			if display_val.indexOf(neg_operators)> -1 and display_val.indexOf("-")> -1
				if display_val.indexOf("-") < display_val.indexOf(neg_operators)
					display_val = display_val.replace(neg_operators,first)
					temp =display_val.slice(display_val.indexOf("-"))
					display_val_remaining = temp.slice(1)
					display_val = display_val.slice(0,display_val.indexOf("+"))+"+0+"+display_val_remaining
					console.log("there is a minus ahead"  + display_val)
				else
					display_val = display_val.replace(neg_operators,first)
					display_val = "0+"+display_val
					console.log("there is no minus ahead" + display_val)
		return display_val
	mixed_level_operation = (a,b,operator)->

	first_level_operation = (a,b,operator)->

	second_level_operation = (a,b,operator)->

	enter_to_calculate = ->
		display_val = $("#display_val").val()
		display_val = remove_comma(display_val)
		operators = get_operators(display_val)
		if  operators.length >= 2
			#complex operation
			if display_val.indexOf("(")>-1 and display_val.indexOf(")")>-1

				final_result = parenthese_cal(display_val)
			else
				final_result = none_parentheses_cal(display_val)
		else
			# single operation
			final_result = none_parentheses_cal(display_val)
		final_result = add_comma(final_result)
		if is_negative
			final_result = "-"+final_result
		$("#display_val").val(final_result)

	countDecimals = (value)->
		if (value % 1) != 0
			decimal_number = value.toString().split(".")[1].length
			if decimal_number > 8
				decimal_number = 8
			return decimal_number
		return 0

	remove_comma = (value)->
		new_value = value.replace(",","")
		return new_value

	add_comma = (value)->
		is_integer = /^\d+$/.test(value)
		# if it is integer, then add comma after every three digits
		if is_integer
			value = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
		# if it is decimal, only add comma after every three digits before the dot
		else
			if value.toString().indexOf("-")> -1
				value = value.toString().replace("-","")
				value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",")
				value = "-"+value
			else
				integer_part = value.split(".")[0]
				decimal_part = value.split(".")[1]
				integer_value = integer_part.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
				value = integer_value+"."+decimal_part
		return value

	parenthese_cal = (display_val)->
		console.log("parenthese equation: "+display_val)
		while display_val.indexOf("+")>-1 or display_val.indexOf("-")>-1 or display_val.indexOf("*")>-1 or display_val.indexOf("/")>-1
			operators = get_operators(display_val)
			regExp = /\(([^)]+)\)/
			matches = regExp.exec(display_val)
			parenthese_value = 0
			negative_inside = false
			if matches
				regExp = /\(([^)]+)\)/
				matches = regExp.exec(display_val)
				priority_operation = matches[0]
				left_value = priority_operation.replace("(","").replace(")","")
				numbers = get_numbers(priority_operation)
				operators = get_operators(left_value)
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
							if operators[index] =="/"
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
				console.log("value inside () is "+left_value)
				continue
			else
				# if the left value is a negative number then loop stop here too
				numbers = get_numbers(display_val)
				operators = get_operators(display_val)
				if numbers.length == 1 and operators.length == 1 and operators[0] =="-"
					display_val = display_val.toString()
					break
				else
					if display_val.indexOf("--") > -1
						display_val = display_val.replace("--","+")
					if display_val.indexOf("+-") > -1
						display_val = display_val.replace("+-","-")
					if display_val.indexOf("*-") > -1
						display_val = handle_neg_value(display_val,"*-")
					if display_val.indexOf("/-") > -1
						display_val =  handle_neg_value(display_val,"/-")
					display_val = none_parentheses_cal(display_val)
					display_val = display_val.toString()
				continue
		return display_val

	none_parentheses_cal = (left_value)->
		console.log("non-parenthese equation: "+left_value)
		if left_value.charAt(0) == "-"
			left_value = "0"+left_value
		# getting all the numbers
		numbers = get_numbers(left_value)
		operators = get_operators(left_value)
		temp_index = 0
		final_result = 0
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
					if operators[index] =="/"
						temp = parseFloat(a)/parseFloat(b)
						decimal_num = countDecimals(temp)
						if decimal_num > 5
							temp = temp.toFixed(5)
						else
							temp = temp.toFixed(decimal_num)
					if numbers.length > 2
						numbers.splice(0,2)
						numbers.unshift(temp)
						temp_index -=1
					else
						final_result = temp
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
									console.log(temp)
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
						else
							return false
					)
		if final_result.toString().indexOf("-")>-1
			is_negative = false
		return final_result

	# iterate through all the keys and add listener to them to decide which operation to take
	$.each(keys,(index, value)->
		$(this).on("click",->
			btn=$(this)
			display_val = $("#display_val").val()
			# to clear current data
			if btn.prop("id") == "clear"
					$("#display_val").val("")
					operator = ""
					has_dot = false
					numbers = []
					operators=[]
					operator_counter = 0
			else
				if btn.prop("id") == "equal"
					enter_to_calculate()
				else
					## input part
					# if dot is already in the number then disable any more dots, but if there is operator after one number then dot is allow for the second number
					last_char = display_val[display_val.length-1]
					if factor_divider.indexOf(last_char) > -1
						factor = display_val.substring(0, display_val.length - 1);
						if factor.indexOf(".")>-1
							has_dot= false
					if btn.hasClass("operator")
						if display_val.length>=1
							operator_counter += 1
							operator = btn.text()
							if factor_divider.indexOf(last_char) > -1
								display_val = display_val.slice(0,-1)
					if btn.prop("id") == "dot"
						#only allow dot when there is none in the data, otherwise, skip it
						if not has_dot
							display_val += btn.text()
							has_dot = true
					else
						append_comma = true
						# forbid multiple 0 at the beginning of the value and first char is operators
						if not(last_char == "0" && btn.text() == "0" and display_val.length == 1) and not(display_val.length==0 and btn.hasClass("operator")) #and not ( "()*/+-".indexOf(last_char)> -1 and "()*/+-".indexOf(btn.text())>-1)
							display_val += btn.text()
							display_val = display_val.replace(/,/g , "")
							comma_count = display_val.length/3
							if comma_count > 2
								display_val = display_val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
							else
								a = display_val.length-3
								next_comma = 1
								move = 0
								while a > 0
									display_val = display_val.slice(0, a+move) + "," + display_val.slice(a+move)
									a -=3
									next_comma +=1
									move +=1
					$("#display_val").val(display_val)
		)
	)
