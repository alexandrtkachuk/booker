
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


App.directive('userlist', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      controller: "cAdmin as cA",
      templateUrl: "Resources/html/partials/userlist.html"
  };
});

App.directive('adminmenu', function() {
		if(getCookie('tai-userrole')==0){
		  return {
			  restrict: 'AE',
			  replace: 'true',
			  controller: "cIndex as cI",
			  template: "<div><hr> <a ui-sref='admin'  ng-bind='cI.melang.value.LANG_employeelist.VALUE'  class='btn btn-primary'></a></div>"
		  };
	}
	else 
	{
		return {};
	}
});



