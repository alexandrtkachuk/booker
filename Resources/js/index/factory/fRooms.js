App.factory('fRooms', function($http, fLang , fCalendar) {
  
  
  var rooms={
			"items": 0,
			"current":null
	  };
  
  //this.temp=lang;
  
 
 rooms.set = function(id){
	 console.log('set roomid:'+id);
	 if(id == getCookie('tai-roomid')){
		return;
		}
	
	document.cookie = "tai-date=";
	 document.cookie = "tai-roomid="+id;
	 
	 setcurrent();
	 
	$('#calendar').fullCalendar('destroy');
	
				fCalendar.goCalendar(
					fLang.lang,
					getCookie('tai-ftime'),
					getCookie('tai-fday')
				);	
				
		
	
	}
 
  
  function setcurrent(){
	  
	   for(var i = 0; i < rooms.items.length; i++)
						{
							if(rooms.items[i].id==getCookie('tai-roomid'))
							{
									rooms.current=rooms.items[i].name;
									break;
							}
						}
	  
	 }
  
  
  if(rooms.items==0){
	  $http.get('api/rooms').success(
					function(data, status, headers, config) {
						console.log(data);
						rooms.items = data;
						
						setcurrent();
					}
				);	
  
	}

	
  return rooms;
  
  
});
