
jQuery( document ).ready(function() {});


function closeNotice(t)
{
	try {
		if(t && FUSION.lib.isElement(t)) {
			$( t.parentNode ).fadeOut( "slow", function() {});
		}
	}
	catch(err) { FUSION.error.logError(err); }
}


function updateAdmin(id, chk)
{
	var uid = id;
	var adm = chk;

	if(!uid || FUSION.lib.isBlank(uid)) {
		return false;
	}

	var info = {
		"type": "POST",
		"path": "/pages/1/updateAdmin",
		"data": {
			"user_id": uid,
			"is_admin": adm
		},
		"func": updateAdminResponse
	};
	FUSION.lib.ajaxCall(info);
}


function updateAdminResponse(h)
{
	var hash = h || {};
}


function disableUser(id, chk)
{
	var uid = id;
	var dis = chk;

	if(!uid || FUSION.lib.isBlank(uid)) {
		return false;
	}

	var info = {
		"type": "POST",
		"path": "/pages/1/disableUser",
		"data": {
			"user_id": uid,
			"is_disabled": dis
		},
		"func": disableUserResponse
	};
	FUSION.lib.ajaxCall(info);
}


function deleteUser(id)
{
	var uid = id;
	if(!uid || FUSION.lib.isBlank(uid)) {
		return false;
	}
	alert("Currently this functionality is not implemented, but it *might* be soon");
	return false;
}


// Validates that the input string is a valid date formatted as "mm/dd/yyyy"
function isValidDate(dateString)
{
	try {
		// First check for the pattern
		if(!/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString))
		{ return false; }

		// Parse the date parts to integers
		var parts = dateString.split("/");
		var day   = 0;
		var month = 0;
		var year  = 0;

		if(parts.length == 3)
		{
			day   = parseInt(parts[1], 10);
			month = parseInt(parts[0], 10);
			year  = parseInt(parts[2], 10);
		}
		else
		{ return false; }

		// Check the ranges of month and year
		if(year < 2000 || year > 2100 || month < 1 || month > 12)
		{ return false; }

		var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

		// Adjust for leap years
		if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
		{ monthLength[1] = 29; }

		// Check the range of the day
		return day > 0 && day <= monthLength[month - 1];
	}
	catch(err) {
		FUSION.error.logError(err);
		return false;
	}
}


function checkUserForm()
{
	var fname = FUSION.get.node("user_first_name").value;
	var lname = FUSION.get.node("user_last_name").value;
	var email = FUSION.get.node("user_email").value;

	if(FUSION.lib.isBlank(fname) || FUSION.lib.isBlank(lname) || FUSION.lib.isBlank(email))
	{
		alert("Please make sure you have a first name, last name, and email address entered!");
		return false;
	}
	return true;
}

