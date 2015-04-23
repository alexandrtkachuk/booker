App.controller('cUpdate',function(fLang , $http ,$filter,  $stateParams, fCalendar){
		 
	var mess ={val:null};
	this.mess=mess;
	this.user = -1;
	this.melang=fLang;
	this.meridian = true;
	this.open =false;
	var info = {val:null};
	//this.i=info;
	this.calendar=fCalendar;
	
	this.recurrence ='no';
	
	//
	
	fCalendar.getevent($stateParams.start, $stateParams.end);
	
	
	
	
	if(getCookie('tai-ftime')=='H(:mm)')
	{
		this.meridian = false;	
	}
	
	
	
	
	
	
	
	
	this.send = function(form)
	{
		
		console.log(this.calendar.info);
		
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

            if(!this.calendar.info)
           { 
                console.log('errr no info');
                mess.val=fLang.value.LANG_warings2.VALUE;
                return;
           }

		
		  var url='api/updateorder/?iduser='+this.user
               +'&start='+parseInt(sdate.getTime()/1000)
               +'&end='+parseInt(edate.getTime()/1000)
               +'&info='+this.calendar.info
               +'&id='+this.calendar.id;
			
			if(this.recurrence == 'yes'){
					url+='&all=1';
			}
			
            console.log(url);

		
		
	}
	
	
	
	
	
	
	
});
