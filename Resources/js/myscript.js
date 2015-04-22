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

/*
function goCalendar(melang, ftime,fday) {
	
	
	var metoday = '';
	var me2='2015-04-17';
    if(!melang)
    {
        //console.log('<');
        melang='ru';
    }
	
	if(!getCookie('tai-date'))
	{
		 //document.cookie = "tai-ftime=h(:mm)t - h(:mm)t";
		 //console.log('++');
		 
		var  date = new Date();
		
		var month = date.getMonth()+1;
		if(month<10)
		{	
			month='0'+month;
		}
		metoday=date.getFullYear()+'-'+month+'-'+date.getDate();
		document.cookie = "tai-date="+metoday;
		//console.log(date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate());
		//console.log(metoday);
		//console.log(me2);
	}
	metoday = getCookie('tai-date');
	
    if(!ftime)
    {
        ftime='h(:mm)t';
    }
    
    //ftime= 'HH:mm { - HH:mm}';
    if(!fday)
    {
        fday=0;
    }

    $('#calendar').fullCalendar({
        header: {
            left: 'prev,next today',
    center: 'title'
        },
    lang: melang,
    firstDay:fday,
    //defaultDate: '2015-02-12',
    defaultDate: metoday,
    editable: true,
    timeFormat: ftime,
    eventClick: function(calEvent, jsEvent, view) {
		window.idevent = calEvent.id;
		window.eventstart =(calEvent.start.unix()-(HOURADD/1000))-1;
		window.eventend =(calEvent.end.unix()-(HOURADD/1000))+1;

       ctrlUpdate.getevent();
       //console.log(ctrlUpdate);
       //angular.element(document.getElementById('cUpdate')).test();
       $('#mymodal').modal()  ; 

    },
    displayEventEnd: true,
    eventLimit: true, // allow "more" link when too many events
    events: function(start, end, timezone, callback) {

    var calendar = $('#calendar').fullCalendar('getCalendar');    
        
        //console.log(calendar.moment(1427673600*1000).unix());

        var moment = calendar.getDate();
		document.cookie = "tai-date="+moment.format();
        $.ajax({
            url: 'api/getorders/',
            data: {
                // our hypothetical feed requires UNIX timestamps
            start:start.unix() ,
            roomid:getCookie('tai-roomid'),
            end: end.unix()
            },
            success: function(doc) {
            console.log(doc);
                        
                var events = [];
                
                var result = JSON.parse(doc);

                for (var i = 0; i < result.length; i++) {
                //console.log(calendar.moment(result[i].time_start *1000 ).format());
                    
                    
                    var el ={
						title:result[i].info,
                        editable:false,    
                        url: '#/',
                        allDay: false,
                        id:result[i].id,
                        start:calendar.moment( result[i].time_start *1000+HOURADD).format(),
                        end:calendar.moment(result[i].time_end *1000+HOURADD).format()
                    };
					
					if(getCookie('tai-userid')==result[i].id_user)
					{
						el.color="green";
					}
                    events.push(el);
                }
                
                
                console.log(events);
                //callback(result);
                        callback(events);
                //console.log(events);
            }
        });

    }            
    });
    
    
    

} */

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


