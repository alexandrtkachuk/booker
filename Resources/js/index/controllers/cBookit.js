App.controller('cBookit',function(fLang , $http){
		
		 this.melang=fLang;
	   this.test = 'me!!';
	   
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
						
					});
	  
	   this.send = function(form)
	   {
		   console.log(form);
		}
	
	
	
	this.meridian = true;
	
	if(getCookie('tai-ftime')=='H(:mm) - H(:mm)')
	{
		this.meridian = false;	
	}
	
	
	
	
	
});
