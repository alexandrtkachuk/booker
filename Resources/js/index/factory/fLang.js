App.factory('fLang', function($http) {
  
  
  var lang={"lang":0,
			"value": 0
	  };
  
  //this.temp=lang;
  
 
  
  $http.get('api/lang').success(
				function(data, status, headers, config) {

					console.log(data);
					lang.value = data.ISTRING;
					console.log(lang.value);
				}
			);	
  
	
	 lang.get = function() {
		return $http.get('api/lang').success(
				function(data, status, headers, config) {
					console.log(data);
					lang.value = data.ISTRING;
				}
			);	
	 
	 }
	 
	 lang.set = function (lang) {
			document.cookie = "tai-lang="+lang;
		 /*
			return $http.get('api/setlang/?set='+lang).success(
				function(data, status, headers, config) {
					console.log(data);
					return data;
					//lang.get();
				}
			);	
			*/	
	 }
	
  return lang;
  
  
});
