
/*App.directive('calendar', function() {
  return {
      restrict: 'AE',
      replace: 'true',
      templateUrl: "Resources/html/partials/cal.html"
  };
});*/



App.directive('adminmenu', function() {
		if(true){
		  return {
			  restrict: 'AE',
			  replace: 'true',
			  //controller: "iControler as ic",
			  template: "<div><b>admin menu</b></div>"
		  };
	}
	else 
	{
		return {};
	}
});



