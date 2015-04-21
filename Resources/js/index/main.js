var App=angular.module('booker',['ui.router']);



App.controller('cIndex',function( fLang , fRooms ){
	 
	
    this.melang=fLang;
    
    this.rooms = fRooms;
    
    langs = { value:null,
			items:[
      {'name':'ru'},
      {'name':'en'}]
	};
    
    
    this.testme="adminmenu";
    
    
    this.langs=langs;
    
    this.mylang=langs;
	 
    
    
    /**load config
						 * */
						 if(!getCookie('tai-roomid'))
						 {
							 document.cookie = "tai-roomid=1";
						 }
						 
						if(!getCookie('tai-ftime'))
						{
							 document.cookie = "tai-ftime=h(:mm)t";
                             console.log('++');
						}
						this.mytime=getCookie('tai-ftime');
						var metime =this.mytime;
						
						console.log(this.mytime);
						if(!getCookie('tai-fday'))
						{
							document.cookie = "tai-fday=0";
						}
						this.day=getCookie('tai-fday');
                        var meday= this.day;
	
	
	fLang.get().then( function(data, status, headers, config)
					{
						console.log(data.data.LANG);
						
						rendcalendar(data.data.LANG);
						
						for(var i = 0; i < langs.items.length; i++)
						{
							if(langs.items[i].name==data.data.LANG)
							{
									langs.value=langs.items[i];
									break;
							}
						}
					});
	
	function rendcalendar(lang)
	{
		$('#calendar').fullCalendar('destroy');
					goCalendar(lang,getCookie('tai-ftime'),
					getCookie('tai-fday'));	
                    //console.log(this.mytime);
                    //console.log(this.day);
	}
	//lang
	this.fun = function()
	{
		fLang.set(this.mylang.value.name);

		fLang.get().then( function(data, status, headers, config)
		{
			console.log(data.data.LANG);
			rendcalendar(data.data.LANG);
		});
					
							
			
	}
	//time
	this.fun2 = function()
	{
		console.log('switch format time='+this.mytime);
		$('#calendar').fullCalendar('destroy');
		goCalendar(this.mylang.value.name,this.mytime,this.day);
		document.cookie = "tai-ftime="+this.mytime;
	}
	//firsday
	
	this.switchday = function()
	{
		    $('#calendar').fullCalendar('destroy');
			goCalendar(this.mylang.value.name,this.mytime,this.day);
			//console.log(this.day);
			document.cookie = "tai-fday="+this.day;
			
			
	} 
	
	
});
