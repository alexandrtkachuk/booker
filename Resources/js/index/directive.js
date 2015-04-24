
/*App.directive('calendar', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      templateUrl: "Resources/html/partials/cal.html"
  };
});*/

App.directive('modaluseradd', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      controller: "cAdmin as cA",
      templateUrl: "Resources/html/partials/adduser.html"
  };
});

App.directive('modaluseredit', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      controller: "cAdmin as cA",
      templateUrl: "Resources/html/partials/edituser.html"
  };
});

App.directive('modaluserdelete', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      controller: "cAdmin as cA",
      templateUrl: "Resources/html/partials/deleteuser.html"
  };
});


App.directive('addroom', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      controller: "cAdmin as cA",
      templateUrl: "Resources/html/partials/addroom.html"
  };
});



App.directive('userlist', function() {
  if(getCookie('tai-userrole')==0){
	  return {
		  restrict: 'AE',
		  replace: 'true',
		  controller: "cAdmin as cA",
		  templateUrl: "Resources/html/partials/userlist.html"
	  };
	}else{ return {
		restrict: 'AE',
		  replace: 'true',
		  
		  template: "<p class='username'>"+getCookie('tai-username')+"</p>"
		}; }
});

App.directive('adminmenu', function() {
		if(getCookie('tai-userrole')==0){
		  return {
			  restrict: 'AE',
			  replace: 'true',
			  controller: "cIndex as cI",
			  template: "<div><hr> <p><a ui-sref='admin'  ng-bind='cI.melang.value.LANG_employeelist.VALUE'  class='btn btn-primary btn-lg btn-block'></a></p> <p><a data-toggle='modal' data-target='#myModalAddRoom' ng-bind='cI.melang.value.LANG_addroom.VALUE' class='btn btn-primary btn-lg btn-block'></a></p></div>"
		  };
	}
	else 
	{
		
	}
});



