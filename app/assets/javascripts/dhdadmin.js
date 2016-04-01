jQuery( document ).ready(function() {

	var gbr = FUSION.get.browser();
	if(gbr.browser && gbr.browser == "IE")
	{
		document.body.style.setProperty("font-family", "'Trebuchet MS', Helvetica, sans-serif", "important");
	}

	$( ".navlink" ).click(function() {
		FUSION.set.overlayMouseWait();
	});

	$( ".btn-primary" ).click(function() {
		FUSION.set.overlayMouseWait();
	});

	var cmc_coldefs = [{ "targets": [ 4 ], "visible": false, "searchable": true },
					   { "targets": [ 7, 8 ], "searchable": false, "orderable": false }];

	$('#post_table').DataTable({
		"order": [[ 0, "desc" ]],
		"pageLength":10,
		"columnDefs": cmc_coldefs
	});

	$( "#post_live_date" ).datepicker({});
/*	$( "#post_live_date" ).datepicker({
		minDate: 0,
		maxDate: "+1M"});*/

	$('#post_live_time').timepicker({ 'timeFormat': 'H:i:s' });


});


function closeNotice(t)
{
	try {
		if(t && FUSION.lib.isElement(t)) {
			$( t.parentNode ).fadeOut( "slow", function() {});
		}
	}
	catch(err) { FUSION.error.logError(err); }
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


function disableUserResponse(h)
{
	var hash = h || {};
}


function checkComicForm()
{
	var file = FUSION.get.node("post_file").value;
	var name = FUSION.get.node("post_file_name").value;
	var cttl = FUSION.get.node("post_title").value;
	var calt = FUSION.get.node("post_alttext").value;
	var csub = FUSION.get.node("post_content").value;
	var golv = FUSION.get.node("post_live_time").value;
	var pnam = FUSION.get.node("post_name").value;
	var rdio = Fusion.get.byName("post[status]");

	var chck = true;
	var rdbt = "";
	for(var elem in rdio)
	{
		if(rdio[elem].checked)
		{
			rdbt = rdio[elem].value;
			chck = false;
		}
	}

	var error = "";
	var missing = "";
	if(FUSION.lib.isBlank(file))
	{
		missing = missing + "\nFile";
	}
	if(FUSION.lib.isBlank(name))
	{
		missing = missing + "\nFile name";
	}
	if(FUSION.lib.isBlank(cttl))
	{
		missing = missing + "\nComic Title";
	}
	if(FUSION.lib.isBlank(calt))
	{
		missing = missing + "\nAlt-text";
	}
	if(FUSION.lib.isBlank(csub))
	{
		missing = missing + "\nSub-text";
	}
	if(chck)
	{
		missing = missing + "\nWhen to post";
	}
	if(!chck && rdbt == "future" && FUSION.lib.isBlank(golv))
	{
		missing = missing + "\nPost date";
	}
	if(missing)
	{
		error = "The following fields are required:\n" + missing;
		alert(error);
		return false;
	}

	var filecheck = false;
	try {
		filecheck = checkFiles(file, name);
		console.log("FILECHECK IS: " + filecheck);
	}
	catch(err) {
		console.log("Error while checking if file exists");
		return false;
	}

	return filecheck;
}


function checkFiles(fl, fn)
{
	var upldfile = fl || "";
	var filename = fn || "";
	if(FUSION.lib.isBlank(upldfile) || FUSION.lib.isBlank(filename)) {
		return false;
	}

	var rez = false;

	$.ajax({
		type: "POST",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("X-CSRF-Token", jQuery('meta[name="csrf-token"]').attr('content'));
			xhr.setRequestHeader("Accept", "text/html");
		},
		async: false,
		url: "/posts/1/checkFileExists",
		data: { newfile: upldfile,
				filenam: filename
		},
		success: function(result) {
			var response = JSON.parse(result);
			if(response['status'] == "success")
			{
				console.log("File does not exist!");
				rez = true;
			}
			else
			{
				alert(response['message'])
			}
		},
		error: function(xhr, errtype, errthrown) {
			switch(errtype) {
				case "error":
					FUSION.lib.alert("<p>Error completing request: " + errthrown + "</p>");
					break;
				case "abort":
					FUSION.lib.alert("<p>Call to server aborted: " + errthrown + "</p>");
					break;
				case "parsererror":
					FUSION.lib.alert("<p>Parser error during request: " + errthrown + "</p>");
					break;
				case "timeout":
					FUSION.lib.alert("<p>Call to server timed out - please try again</p>");
					break;
				default:
					FUSION.error.showError("The call to the server failed", "AJAX Error");
			}
		}
	});
	return rez;
}


function checkAnnouncementForm()
{
	try {
		var annc = FUSION.get.node("announcement_content");
		var auid = FUSION.get.node("announcement_user_id");
		if(FUSION.lib.isBlank(annc.value)) {
			alert("Please enter some content for this announcement!");
			return false;
		}
		if(FUSION.lib.isBlank(auid.value)) {
			alert("There was an issue verifying your identity - please refresh the page and try again");
			return false
		}
		return true;
	}
	catch(err) {
		FUSION.error.logError(err);
		return false;
	}
}


function updateAnnouncementActive(t)
{
	var chk = t || {};
	if(!t) {
		return false;
	}

	var el_id = chk.id.split("_");
	var aid = el_id[el_id.length - 1];
	var info = {
		"type": "POST",
		"path": "/announcements/" + aid + "/activeAnnouncement",
		"data": {
			"announcement_id": aid,
			"is_active": chk.checked
		},
		"func": updateAnnouncementActiveResponse
	};
	FUSION.lib.ajaxCall(info);
}


function updateAnnouncementActiveResponse(h)
{
	var hash = h || {};
}


function ignoreEnter(event)
{
	var keynum = -1;
	if(window.event){ // IE
		keynum = event.keyCode;
	}
	else if(event.which) { // Chrome/Firefox/Opera
		keynum = event.which;
	}

	if(keynum == 13)
	{
		event.preventDefault();
	}
}


function updateField(e, t, i)
{
	var elm = e || null;
	var typ = t || "";
	var uid = i || 0;
	var cur = parseInt(FUSION.get.node("current_user_id").value);

	if(!elm || FUSION.lib.isBlank(typ) || uid == 0) {
		console.log("Error during update - insufficient data for submission");
		return false;
	}

	var txt = elm.textContent;

	if(FUSION.lib.isBlank(txt) || txt.match(/^\s*<br\s*(\/)?>\s*$/)) {
		alert("Blank values are not allowed!");
		elm.focus();
		return false;
	}

	var data = {};
	switch (typ) {
		case "name":
			var narry = txt.split(" ");
			var fname = narry[0];
			var lname = "";
			if(narry.length > 1) {
				var larry = narry.slice(1, narry.length);
				lname = larry.join(" ");
			}
			data['first_name'] = fname;
			data['last_name']  = lname;
			break;
		case "email":
			if(!txt.match(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b/))
			{
				alert("Please make sure you've entered a valid email address!");
				elm.focus();
				return false;
			}
			data['email'] = txt;
			break;
		default:
			alert("Not able to determine what you wanted to update\n\nPlease refresh the page and try again");
			return false;
			break;
	}

	var info = {
		"type": "POST",
		"path": "/pages/" + uid + "/updateUserInfo",
		"data": {
			"user_id": uid,
			"field_data": data,
			"user_req_update": cur
		},
		"func": updateUserInfoResponse
	};
	FUSION.lib.ajaxCall(info);
}


function updateUserInfoResponse(h)
{
	var hash = h || {};
}


function resetPassword(id)
{
	var uid = id || 0;
	if(uid == 0) {
		alert("No user selected - please refresh the page and try again");
		return false;
	}
	var yn = confirm("Are you sure you want to reset this user's password?");
	if(yn)
	{
		var info = {
			"type": "POST",
			"path": "/pages/" + uid + "/resetPassword",
			"data": {
				"user_id": uid
			},
			"func": resetPasswordResponse
		};
		FUSION.lib.ajaxCall(info);
	}
}


function resetPasswordResponse(h)
{
	var hash = h || {};
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

