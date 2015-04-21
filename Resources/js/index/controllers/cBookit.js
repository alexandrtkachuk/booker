App.controller('cBookit',function(fLang , $http,fRooms){
		 
		this.rooms = fRooms;
		this.melang=fLang;
		this.test = 'me!!';
		this.user = -1;
		this.info ; //info for rooms
		this.recurrence='none';
		this.typerecurrence=1;
		this.count=1;
	   fLang.get().then( function(data, status, headers, config)
					{
						if(fLang.lang=='ru')
						{
							datapickerRu();
						}
						else
						{
							godatapicker();
						}
						
						$('#timepicker1').timepicker();
						$('#timepicker2').timepicker();
						
					});
	  
	   this.send = function(form)
	   {
		   console.log(form);
		   /*idroom
		    * start
		    * end
		    * info
		    * iduser
		    * recurrence
		    * count*/
		    
		    
		    
		     console.log($('#timepicker1').val());
		     var hours = $('#timepicker1').val().split(':')
		     var date = new Date($('.datepicker').datepicker('getDate'));
		     date.setUTCHours(hours[0],hours[1]);
		     console.log(date);
		    
		    
		}
	
	
	
	this.meridian = true;
	
	if(getCookie('tai-ftime')=='H(:mm)')
	{
		this.meridian = false;	
	}
	
	
});
