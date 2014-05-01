# This is in app/assets/javascript/controllers/main
app = angular.module('NgApp')

# This guy takes a service that we've already created, 'CrimeReport', and does the simplest query.
# I'm not sure if 'query' is the only method that a person could call on this service. Regardless,
# we stick the results in our '$scope' object that will exist in the view. So we can just use the
# the 'crime_reports' object.
app.controller 'CrimeReportsController', ['$scope', '$location', '$http', 'CrimeReport', 'CrimeReportService', 'CrimeReportSearch', ($scope, $location, $http, CrimeReport, CrimeReportService, CrimeReportSearch) ->
  $scope.btnText = 'New'
  $scope.crime_reports = CrimeReport.all()
  
  # Init our view
  $scope.mapvals = {}
  $scope.mapvals.date = new Date().toISOString().slice(0, -5);
  $scope.mapvals.window = 15
  $scope.mapvals.radius = 5

  # This is our google maps object. Here we can specify defaults, controls, and who knows
  # what else!
  $scope.map = {
    control: {}
    options:
      disableDefaultUI: true
      panControl: false
      navigationControl: false
      scrollwheel: true
      scaleControl: false
    center: {
      # ISSUE: It would be awesome if this was pulled from the user session: last clicked lat,lon
      latitude: 47.3
      longitude: -122.2
      }
    zoom: 9
    events: {
      mouseover: ->
        console.log "I have been moused"
      click: ->
        console.log "I have been clicked"
    }

    mapevents: {
      # The param happens to be the lat,lon
      rightclick: (mapModel, eventName, origArgs)->
        $scope.mapvals.mapClickedValue = origArgs[0].latLng.lat() + " and " + origArgs[0].latLng.lng()
        $scope.crime_reports = CrimeReportSearch.search(
            lat: origArgs[0].latLng.lat()
            lng: origArgs[0].latLng.lng()
            radius: $scope.mapvals.radius
            starttime: 'null' # ISSUE this needs to be fixed.
            endtime: 'null'
          )
        # Should put together an http request here. Should turn this into a resource!!
        # $http.get(
        #   url: "/api/crime_reports/search"
        #   params:
        #     lat: origArgs[0].latLng.lat()
        #     lng: origArgs[0].latLng.lng()
        #     radius: $scope.mapvals.radius
        #     starttime: 'null' # ISSUE this needs to be fixed.
        #     endtime: 'null'
        #   ).success( (data, status, headers, config)->
        #       $scope.crime_reports = data
        #     )
        $scope.$apply()
    }
  }
  $scope.deleteReport = (id, idx) ->
    # This doesn't work when sorting.
    $scope.crime_reports.splice(idx, 1)
    CrimeReport.delete(id)
  $scope.signupForm = ->
    # Clears the form like a boss.
    newreport = CrimeReport.create($scope.crimereport)
    $scope.crime_reports.push(newreport)
    $scope.crimereport = {}
    $scope.crimereportform.$setPristine()
    $scope.switchBtnText()
    # this was needed, but now is undefined??
    # $scope.crimereportform.$setValid()
  $scope.switchBtnText = ->
    $scope.shownewform = !$scope.shownewform
    $scope.btnText = if $scope.shownewform then 'Cancel' else 'New' 
  $scope.viewReport = (cReport) ->
    CrimeReportService.setReport(cReport)
    $location.url "/#{cReport.id}"
]

# Controller that lets us view a single crime report. Notice how we nested a filter
# in the midst of this. This is probably not the way we are supposed to do things.
# this should go in it's own file location perhaps and be important to via the page
# scripts.
app.controller 'CrimeReportShowController', ['$scope', '$routeParams', 'CrimeReportService', ($scope, $routeParams, CrimeReportService) ->
  $scope.report = CrimeReportService.getReport()
  # a sort of custom filter or check.
  $scope.isDate = (key, value) ->
    Date.parse(value) > 0 && key != 'id'
]
