App.controller('cUpdate',function(fLang , $http ,$filter, fData , $stateParams, fCalendar){
		 
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
		
		console.log(fData.info);
		
		console.log("show"+fData.show);
	}
	
	
	
	
	
	
	
});
