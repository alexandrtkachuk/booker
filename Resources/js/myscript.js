/**load config
						 **/
						 
						 
						 var d = new Date();
						 var HOURADD = (-1*(d.getTimezoneOffset()))*60000;
						 console.log(HOURADD);
						 
						 if(!getCookie('tai-roomid'))
						 {
							document.cookie = "tai-roomid=1";
						 }
						 
						if(!getCookie('tai-ftime'))
						{
							 document.cookie = "tai-ftime=h(:mm)t";
                            
						}
						
						
						if(!getCookie('tai-fday'))
						{
							document.cookie = "tai-fday=0";
						}


var ctrlUpdate;
function getValue(temp)
{
	ctrlUpdate=temp;
}


function getCookie(name) {
  var matches = document.cookie.match(new RegExp(
    "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}



function godatapicker(data){
	
	
	if(!getCookie('tai-fday'))
						{
				document.cookie = "tai-fday=0";
						}
	
	$('.datepicker').datepicker({
		weekStart: getCookie('tai-fday') ,
		language: 'en',
		daysOfWeekDisabled: [0,6]
	});
	
	if(!data)
	{
		data= new Date();
	}
	
	$('.datepicker').datepicker('update', data);
		
		
	
	
	
	
	
	
}
	
	
function datapickerRu(data){
	
	if(!getCookie('tai-fday'))
						{
							document.cookie = "tai-fday=0";
						}
	
	$('.datepicker').datepicker({
		language: 'ru',
		weekStart: getCookie('tai-fday') ,
		daysOfWeekDisabled: [0,6]
	});
	
	
	if(!data)
	{
		data= new Date();
	}
	
	$('.datepicker').datepicker('update', data);
	
	
}


function am_pm_to_hours(time) {
    console.log(time);
    var hours = Number(time.match(/^(\d+)/)[1]);
    var minutes = Number(time.match(/:(\d+)/)[1]);
    var AMPM = time.match(/\s(.*)$/)[1];
    if (AMPM == "PM" && hours < 12) hours = hours + 12;
    if (AMPM == "AM" && hours == 12) hours = hours - 12;
    var sHours = hours.toString();
    var sMinutes = minutes.toString();
    if (hours < 10) sHours = "0" + sHours;
    if (minutes < 10) sMinutes = "0" + sMinutes;
    return (sHours +':'+sMinutes);
}



