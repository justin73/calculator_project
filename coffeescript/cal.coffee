jQuery ->
	$ = jQuery
	# get all the pressable keys
	keys= $("#calculator span")
	cal_obj = {a:0,b:0}
	operator = ""
	# iterate through all the keys and add listener to them to decide which operation to take
	$.each(keys,(index, value)->
		$(this).on("click",->
			btn=$(this)
			display_val = $("#display_val").text()
			if btn.prop("id") == "clear"
					$("#display_val").text("")
			else
				if btn.prop("id") == "equal"
					cal_obj.b = $("#display_val").text().replace(cal_obj.a+operator,"")
					if operator == "+"
						final_result = parseFloat(cal_obj.a)+parseFloat(cal_obj.b)
					if operator =="-"
						final_result = parseFloat(cal_obj.a)-parseFloat(cal_obj.b)
					if operator =="x"
						final_result = parseFloat(cal_obj.a)*parseFloat(cal_obj.b)
					if operator =="/"
						final_result = parseFloat(cal_obj.a)/parseFloat(cal_obj.b)
					$("#display_val").text(final_result)
				else
					if btn.hasClass("operator")
						cal_obj.a = $("#display_val").text()
						operator = btn.text()
					display_val += btn.text()
					$("#display_val").text(display_val)
			# if operator !=""
			# 	$("#display_val").text("")
			# display_val = $("#display_val").text()
			# # for number keys, just need to display the value of button
			# if $(this).hasClass("number")
			# 	display_val += btn.text()
			# 	$("#display_val").text(display_val)
			# else
			# 	# if it is clear, then erase everything on the display bar
			# 	if btn.prop("id") == "clear"
			# 		$("#display_val").text("")
			# 	else
			# 		if btn.prop("id") == "equal"
			# 			console.log($("#display_val").text())
			# 			cal_obj.b = $("#display_val").text()
			# 			final_result = cal_obj.a + cal_obj.b
			# 			$("#display_val").text(final_result)
			# 		else
			# 			if btn.hasClass("operator")
			# 				operator = btn.prop("id")
			# 				cal_obj.a = $("#display_val").text()

		)
	)