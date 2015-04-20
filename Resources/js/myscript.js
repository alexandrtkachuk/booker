/**load config
						 * */
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
                    events.push({
                        title:result[i].info,
                        editable:false,    
                        allDay: false,
                        start:calendar.moment(result[i].time_start *1000 ).format(),
                        end:calendar.moment(result[i].time_end *1000 ).format()
                    });
                }
                
                
                console.log(events);
                //callback(result);
                        callback(events);
                //console.log(events);
            }
        });

    }            
    });

} //

function getCookie(name) {
  var matches = document.cookie.match(new RegExp(
    "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
  ));
  return matches ? decodeURIComponent(matches[1]) : undefined;
}



function godatapicker(){
	
	
	if(!getCookie('tai-fday'))
						{
							document.cookie = "tai-fday=0";
						}
	
	$('.datepicker').datepicker({
		weekStart: getCookie('tai-fday') ,
		daysOfWeekDisabled: [0,6]
	});
	$('.datepicker').datepicker('update', new Date());
		
		
	
	
	
	
	
	
}
	
	
function datapickerRu(){
	
	if(!getCookie('tai-fday'))
						{
							document.cookie = "tai-fday=0";
						}
	
	$('.datepicker').datepicker({
		language: 'ru',
		weekStart: getCookie('tai-fday') ,
		daysOfWeekDisabled: [0,6]
	});
	
	
	
	
	$('.datepicker').datepicker('update', new Date());
}




 
