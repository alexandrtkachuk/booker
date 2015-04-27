App.factory('fData', function( ) {
	
	var data=
	{
		iduser:-1,
		iduser: {id:-1},
		temp:null
	};
	
	
	data.searchUser = function(users){
		if(!data.temp) {
			return;
		}	
		console.log('search user');
		for(var i = 0; i < users.length; i++) {
			if(data.temp==users[i].id)
			{
				data.iduser=users[i];
				return;
			}
			 
		}
	
	}
	return data;
});


App.factory('fCalendar', function( fLang, $filter,fData ) {
	
	var calendar = {
			goCalendar:null,
			info:null,
			show:'none',
			id:null,
			iduser:-1
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
				console.log('calendar info:'+result[0].info);
				if(result[0].count>1)
				{
					calendar.show ='block';
				}
				
				calendar.id = result[0].id;
				fData.temp = (result[0].id_user*1);
				console.log(fData.temp);
				
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
	
	console.log('goCalendar');	
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
			left: 'prevYear,  prev ',
            right: 'next, nextYear, today',
            
		center: 'title'
        },
    lang: melang,
    firstDay:fday,
    //defaultDate: '2015-02-12',
    defaultDate: metoday,
    editable: true,
    timeFormat: ftime,
	  eventClick: function(calEvent, jsEvent, view) {
		  
		  console.log(calEvent);
		 
		  
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
				
				function WaitForClose() {				
					if(!newWin.closed)
					{					
						setTimeout(WaitForClose, 300);
					}
					else
					{								

						$('#calendar').fullCalendar( 'refetchEvents' );	
						console.log('close');		
					}
				}
			
				WaitForClose();
			}
    },
    eventDragStop:function( event, jsEvent, ui, view ) 
    { /*
			console.log(event);
			
			$.ajax({
            url: 'api/getorders/',
            data: {
				start:event.start.unix()  ,
				roomid:getCookie('tai-roomid'),
				end: event.end.unix()
            },
            success: function(doc) {
				
				
				}
			});
			
			
			console.log(event.start.unix());
			console.log(event.end.unix());
			
			
			
			console.log(jsEvent);
			console.log(ui);
			console.log(view);
			*/
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
				
				var date = new Date();
				
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
					
					
					if(date.getTime()<(result[i].time_start *1000) && (getCookie('tai-userid')==result[i].id_user || getCookie('tai-userid')==1))
					{
						el.meurl  = '#/update/'+result[i].time_start+'/'+result[i].time_end;
						el.url='#';
						el.startme = result[i].time_start;
						el.endme =result[i].time_end;
						//el.editable = true;
					}
                    else
                    {
                        //el.meurl  = '#/updateno/'+result[i].time_start+'/'+result[i].time_end;
						//el.url='#';
						//el.startme = result[i].time_start;
						//el.endme =result[i].time_end;

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
