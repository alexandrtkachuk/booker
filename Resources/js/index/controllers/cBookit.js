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

           var url='/?idroom='+getCookie('tai-roomid');

           //console.log($('#timepicker1').val());
           var time = $('#timepicker1').val(); 

           if(getCookie('tai-ftime')=='h(:mm)t' )
           {
                time = am_pm_to_hours(time); 
           } 

           var res = time.split(':');
           var sdate = new Date($('.datepicker').datepicker('getDate'));
           sdate.setHours(res[0],res[1]);
           
           time = $('#timepicker2').val(); 

           if(getCookie('tai-ftime')=='h(:mm)t' )
           {
                time = am_pm_to_hours(time); 
           } 

           var res = time.split(':');
           var edate = new Date($('.datepicker').datepicker('getDate'));
           edate.setHours(res[0],res[1]);

            
           if(sdate.getTime()>=edate.getTime())
           { 
                console.log('errr');
                return;
           }

            if(!this.info)
           { 
                console.log('errr no info');
                return;
           }



        
           var url='api/addorder/?idroom='+getCookie('tai-roomid')
               +'&start='+parseInt(sdate.getTime()/1000)
               +'&end='+parseInt(edate.getTime()/1000)
               +'&info='+this.info
               +'&iduser='+this.user;

            console.log(url);
            
            $http.get(url).success(
				function(data, status, headers, config) {

					console.log(data);
                });	

           //console.log(parseInt(sdate.getTime()/1000));
           //console.log(this.info);
           //console.log(this.info);
            
       }



	this.meridian = true;
	
	if(getCookie('tai-ftime')=='H(:mm)')
	{
		this.meridian = false;	
	}
	
	
});
