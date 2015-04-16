var App=angular.module('booker',['ui.router']);



App.controller('cIndex',function( fLang ){
	
	
    this.melang=fLang;
    
    this.times = [
      {name:'12' , format:'h(:mm)t'},
      {name:'24' , format:'H(:mm)'}
    ];
    
    
    langs = { value:null,
			items:[
      {'name':'ru'},
      {'name':'en'}]
	};
    
    
    this.langs=langs;
    
    this.mylang=langs;
    this.mytime=this.times[0];
    
   
	//goCalendar();
	
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
					goCalendar(lang);	
	}
	
	this.fun = function()
	{
		fLang.set(this.mylang.value.name).then( function(data, status, headers, config)
			{
					fLang.get().then( function(data, status, headers, config)
					{
						console.log(data.data.LANG);
						rendcalendar(data.data.LANG);
					});
					
					
			}) ;
			
			
	}
	
	this.fun2 = function()
	{
		console.log('switch format time');
		$('#calendar').fullCalendar('destroy');
		goCalendar(this.mylang.value.name,this.mytime.format);
			
	}
	
	this.day=1;
	this.switchday = function()
	{
		    $('#calendar').fullCalendar('destroy');
			goCalendar(this.mylang.value.name,this.mytime.format,this.day);
			//console.log(this.day);
	} 
	
	
});
