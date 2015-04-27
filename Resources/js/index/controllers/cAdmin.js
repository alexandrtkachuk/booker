App.controller('cAdmin',function(fCalendar, fLang , $http , fRooms ,fData, $stateParams, $filter){
	
	this.melang=fLang;
	//this.test =;
	var users = {items:null};
	this.users=users;
	this.pass=null;
	
	function getUserList(){
		if(!$stateParams.start)
		{
			$http.get('api/userlist').success(
				function(data, status, headers, config) {
					fData.iduser=fData.temp;
					console.log(data);
					users.items=data;
					console.log('get users');
				}
			);
		}
		else
		{
		var start = $stateParams.start;
		var end = $stateParams.end;
		start--;
		end++;
		var url = 'api/getorders/?start='+start 
		+'&roomid='+getCookie('tai-roomid')
		+'&end='+end;
		
		console.log(url);
		$http.get(url).success(
				function(data, status, headers, config) {
				console.log(data);
				var result = data;
				fCalendar.info=result[0].info;
				console.log('calendar info:'+result[0].info);
				if(result[0].count>1)
				{
					fCalendar.show ='block';
				}
				
				fCalendar.id = result[0].id;
				fData.temp = (result[0].id_user*1);
				console.log(fData.temp);
				
				var s =new Date();
				s.setTime(result[0].time_start*1000);
		
				var e =new Date();
				e.setTime(result[0].time_end*1000);
				
				
				
				var str =$filter('date')(s.getTime(), 'h:mm a');
				
				//
				$('#timepicker1').timepicker('setTime', str);
                $('#timepicker2').timepicker('setTime',$filter('date')(e.getTime(), 'h:mm a'));
                
                
                //////////////
						if(fLang.lang=='ru')
						{
							datapickerRu(s);
						}
						else
						{
							godatapicker(s);
						}
					//run to get current user
					$http.get('api/userlist').success(
						function(data, status, headers, config) {
							fData.iduser=fData.temp;
							console.log(data);
							users.items=data;
							console.log('get users for update');
							fData.searchUser(data)
						}
					);
						
			});

				 
		}	
	}
	this.name=null;
	this.email=null;
	var res={mess:null};
	this.error=res;
	this.adduser = function()
	{
			res.mess = null;
			console.log(this.name);
			console.log(this.email);
			
			
			if(!this.name || !this.email)
			{
				this.error.mess= this.melang.value.LANG_warings2.VALUE;
				return ;
			}
			
			var url = 'api/adduser/?name='+this.name+'&email='+this.email;
			
			$http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==1)
					{
						res.mess = fLang.value.LANG_goodadd.VALUE+'!'+fLang.value.LANG_passemployee.VALUE+':'+data.pass;
					}
					else
					{
						res.mess =fLang.value.LANG_warings2.VALUE;
					}
					
					console.log(data);
					getUserList();
				}
			);	
	}//end adduser
	
	
		this.iduser =null;
			this.edit = function(id, name , email)
			{
				console.log(id);
				this.name = name;
				this.email=email;
				this.iduser=id;
				res.mess = null;
			}
			
		this.sendedit = function()
		{
			if(!this.name || !this.email)
			{
				this.error.mess= this.melang.value.LANG_warings2.VALUE;
				return ;
			}
			
			var temp = 
			{
				name:this.name,
				email:this.email,
				id: this.iduser
			};
			
			var url = 'name='+this.name+'&email='+this.email+'&id='+this.iduser;
			if(this.pass)
			{
				temp.pass = this.pass;
			}
			console.log(url);
			console.log(temp);
			$http.post('api/updateuser/',temp).success(
				function(data, status, headers, config) {
					if(data.warings==0)
					{
						res.mess = fLang.value.LANG_goodedit.VALUE+'!';
					}
					else
					{
						res.mess =fLang.value.LANG_warings2.VALUE;
					}
					
					console.log(data);
					getUserList();
				}
			);	
			}// end edit
	
	this.addroom = function()
	{
			if(!this.name )
			{
				this.error.mess= this.melang.value.LANG_warings2.VALUE;
				return ;
			}
			var url = 'api/addroom/?name='+this.name;
			
			$http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==1)
					{
						res.mess = fLang.value.LANG_goodadd.VALUE+'!';
						fRooms.update();
					}
					else
					{
						res.mess =fLang.value.LANG_warings2.VALUE;
					}
					
					console.log(data);
				
				}
			);	
			
			
			
	}	//end addroom
			
	this.deleteuser = function(id, name)
	{
				console.log(id);
				this.iduser=id;
				this.name = name;
				res.mess = null;
	}
			
	this.senddelete = function()
		{
			var url = 'api/deleteuser/?id='+this.iduser;
			console.log(url);
			$http.get(url).success(
				function(data, status, headers, config) {
					if(data.warings==0)
					{
						res.mess = fLang.value.LANG_goodremove.VALUE+'!';
						
					}
					else
					{
						res.mess =fLang.value.LANG_warings2.VALUE;
					}
					
					console.log(data);
					getUserList();
				}
			);	
			} //end user remove
		
	getUserList();
	
	
});
