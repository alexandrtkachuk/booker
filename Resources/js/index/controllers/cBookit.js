App.controller('cBookit',function(fLang , $http, fRooms,fData){
		this.errcolor=null;
		this.rooms = fRooms;
		this.melang=fLang;
		this.test = 'me!!';
		this.user = fData;
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
		
		
		var mess ={val:null};
		this.mess=mess;
		
	this.setcount = function()
	{
			console.log(this.count);
			this.count = 1;
	}	
		
       this.send = function(form)
       {
           //console.log(form);
           this.errcolor=null;
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
                mess.val=fLang.value.LANG_warings2.VALUE;
                return;
           }

            if(!this.info)
           { 
                console.log('errr no info');
                mess.val=fLang.value.LANG_warings2.VALUE;
                return;
           }

			if(this.count>this.typerecurrence)
			{
					 console.log('errr count');
					 this.errcolor="red";
					 mess.val=fLang.value.LANG_warings2.VALUE;
					 return;
			}
           var iduser;
           
				if( !this.user.iduser  ||  this.user.iduser.id == -1)
				{
						iduser=-1;
				}
				else
				{
					iduser=this.user.iduser.id;
				}
				


        
           var url='api/addorder/?idroom='+getCookie('tai-roomid')
               +'&start='+parseInt(sdate.getTime()/1000)
               +'&end='+parseInt(edate.getTime()/1000)
               +'&info='+this.info
               +'&iduser='+iduser;
			
			if(this.recurrence == 'block')
			{
					url+='&recurrence='+this.typerecurrence
					+'&count='+this.count;
			}
			
            console.log(url);
            
            $http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==5){
						mess.val=fLang.value.LANG_goodadd.VALUE;
					}
					else
					{
						if(typeof(data.staffuser) == "undefined" ){
							mess.val=fLang.value.LANG_eventonaday.VALUE;
						}else {
							mess.val=fLang.value.LANG_staffmeeting.VALUE+data.staffuser;
						}
						
						
					}
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
