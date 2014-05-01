# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# The below structure is very important. We want to call ourselves first so that we
# can reuse the 'app' var in later files.

#= require_self
#= require_tree ./angular/controllers
#= require_tree ./angular/services

# Ok lets be clear this little directive below initializes the app
# for the html page. That's why we have to require self before we go
# looking for other js files. Within those file we just have to reference
# the 'app' variable. like this: 'app = angular.module('NgApp')'
app = angular.module('NgApp', ['ngResource', 'ngRoute', 'ngAnimate', 'google-maps'])

app.config(['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
	# this puts me in an infinite loop for some reason.
	# $locationProvider.html5Mode(true)
	$routeProvider.
	when('/', {
		 templateUrl: '../templates/home.html',
		 controller: 'CrimeReportsController'
		}).
	when('/:id', {
		templateUrl: 'templates/crimereport.html',
		controller: 'CrimeReportShowController'
		}).
	otherwise({
		redirectTo: '/'
		})
	])

# This should probably go in it's own file. Simply takes an input
# and if it's value it will attempt to capitalize it and remove underscores.
app.filter('capitalize', -> (input) ->
	if (input)
		input[0].toUpperCase() + input.slice(1).replace("_", " ")
)