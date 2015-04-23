


App.factory('fCalendar', function( fLang, $filter ) {
	
	var calendar = {
			goCalendar:null,
			info:null,
			show:'none',
			id:null
		}; 
	
	calendar.test = function()
	{
		return calendar.info;
			//console.log('cal test');
	}
	
	 calendar.getevent = function(start,end)
	{
		
		start--;
		end++;
			$.ajax({
            url: 'api/getorders/',
            data: {
				start:start  ,
				roomid:getCookie('tai-roomid'),
				end: end
            },
            success: function(doc) {
			
				
				var result = JSON.parse(doc);
				console.log(doc);
				
				calendar.info=result[0].info;
				if(result[0].count>1)
				{
					calendar.show ='block';
				}
				
				calendar.id = result[0].id;
				calendar.iduser = result[0].id_user;
				var s =new Date();
				s.setTime(result[0].time_start*1000);
		
				var e =new Date();
				e.setTime(result[0].time_end*1000);
				
				
				
				var str =$filter('date')(s.getTime(), 'h:mm a');
				
				//
				$('#timepicker1').timepicker('setTime', str);
                $('#timepicker2').timepicker('setTime',$filter('date')(e.getTime(), 'h:mm a'));
                
                
                //////////////
                if(fLang.lang=='ru')
						{
							datapickerRu(s);
						}
						else
						{
							godatapicker(s);
						}
			}
				
			});	
			
			//$scope.myValue = true;
	}
	
	calendar.goCalendar = function(melang, ftime,fday) {
	
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
		if(calEvent.url)
		{	
			var w=500;
			var h=400;
			 var left = (screen.width/2)-(w/2);
			 var top = (screen.height/2)-(h/2);
			var newWin = window.open(calEvent.meurl,
					"test",
					"width="+w+",height="+h+",resizable=yes,scrollbars=yes,status=yes,location=yes"
					+"left="+left+",top= "+top
				)

			newWin.focus();
		}
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
                     
                        allDay: false,
                        id:result[i].id,            
                        start:calendar.moment( result[i].time_start *1000+HOURADD).format(),
                        end:calendar.moment(result[i].time_end *1000+HOURADD).format()
                    };
					
					if(getCookie('tai-userid')==result[i].id_user)
					{
						el.color ="green";
					}
					
					
					if(getCookie('tai-userid')==result[i].id_user || getCookie('tai-userid')==1)
					{
						el.meurl  = '#/update/'+result[i].time_start+'/'+result[i].time_end;
						el.url='#';
						
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
    
} //
	
	return calendar;
});
