App.config(function($stateProvider, $urlRouterProvider) {
	  
	  $urlRouterProvider.otherwise("/");
	  
	  $urlRouterProvider.when('/admin', [ function () {
            
            if(getCookie('tai-userrole')!=0)
            {
					return '/'; 
			}
            
            return false;
		}]);
	
	  
	  
	
	$stateProvider
		.state('index', {
		  url: "/",
		   controller: "cIndex as cI",
		  templateUrl: "Resources/html/partials/index.html"
		})
	
	
		.state('bookit', {
		  url: "/bookit",
		   controller: "cBookit as cB",
		  templateUrl: "Resources/html/partials/bookit.html"
		})
		
		.state('update', {
		  url: "/update/{start}/{end}",
		  controller: "cUpdate as cB",
		  templateUrl: "Resources/html/partials/update.html"
		})
		
        .state('updateno', {
		  url: "/updateno/{start}/{end}",
		  controller: "cUpdate as cB",
		  templateUrl: "Resources/html/partials/updateno.html"
		})

		
		.state('admin', {
		  url: "/admin",
		   controller: "cAdmin as cA",
		  templateUrl: "Resources/html/partials/admin.html"
		})

  });
