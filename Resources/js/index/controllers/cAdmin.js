App.controller('cAdmin',function(fLang , $http){
	
	this.melang=fLang;
	this.test ='test';
	var users = {items:null};
	this.users=users;
	
	function getUserList(){
	
	$http.get('api/userlist').success(
				function(data, status, headers, config) {

					console.log(data);
					users.items=data;
				}
			);	
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
			
			var url = 'api/updateuser/?name='+this.name+'&email='+this.email+'&id='+this.iduser;
			console.log(url);
			$http.get(url).success(
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