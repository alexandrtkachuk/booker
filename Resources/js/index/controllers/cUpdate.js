App.controller('cUpdate',function(fLang , $http ,$filter,  $stateParams, fCalendar ,fData){
		 
	var mess ={val:null};
	this.mess=mess;
	this.user = fData;
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
		
			var stime = $('#timepicker1').val(); 

           if(getCookie('tai-ftime')=='h(:mm)t' )
           {
                stime = am_pm_to_hours(stime); 
           } 

           
          
           
           var etime = $('#timepicker2').val(); 

           if(getCookie('tai-ftime')=='h(:mm)t' )
           {
                etime = am_pm_to_hours(etime); 
           } 

          

      

            if(!this.calendar.info)
           { 
                console.log('errr no info');
                mess.val=fLang.value.LANG_warings2.VALUE;
                return;
           }
				
				var iduser;
				if(!this.user.iduser.id)
				{
						iduser=this.user.temp;
				}
				else
				{
					iduser=this.user.iduser.id;
				}
				
		
		  var url='api/updateorder/?iduser='+iduser
			   +'&idroom='+getCookie('tai-roomid')
               +'&start='+stime
               +'&end='+etime
               +'&info='+this.calendar.info
               +'&id='+this.calendar.id;
			
			if(this.recurrence == 'yes'){
					url+='&all=1';
			}
			
            console.log(url);

			
			$http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==5){
						mess.val=fLang.value.LANG_goodadd.VALUE;
					}
					else
					{
						mess.val=fLang.value.LANG_warings2.VALUE;
					}
					console.log(data);
                });	
		
	}
	
	this.delete = function()
	{
		var is = confirm(fLang.value.LANG_dialogremoveevent.VALUE+"?");

		if(!is){
			return ;
		}
		
		  var url='api/deleteorders/?id='+this.calendar.id;
			
			if(this.recurrence == 'yes'){
					url+='&all=1';
			}
			
            console.log(url);

			
			$http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==5){
						mess.val=fLang.value.LANG_removeevent.VALUE;
					}
					else
					{
						mess.val=fLang.value.LANG_warings2.VALUE;
					}
					console.log(data);
                });	
		
	}
	
	
	
	
	
});
