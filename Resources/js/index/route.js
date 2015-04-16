App.config(function($stateProvider, $urlRouterProvider) {
	  
	  $urlRouterProvider.otherwise("/");
	  
	
	  
	  
	
	$stateProvider
		.state('index', {
		  url: "/",
		   controller: "cIndex as cI",
		  templateUrl: "Resources/html/partials/index.html"
		})
	
	
		

  });
