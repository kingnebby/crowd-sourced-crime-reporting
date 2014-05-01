# Need to get our html app.
app = angular.module('NgApp')

# This is going to tell us that we need to go get some data. The factory is like a data-access method that you'd
# find in other applications. We've given a name that our Controllers can use, and we pass it the '$resource'
# var that a separate library will know what to do with. We simply pass this var two variables, the path, and
# the :id(? I'm not sure why the id)

app.factory 'CrimeReport', ['$resource', ($resource) ->
	new class CrimeReport
		constructor: ->
			this.service = $resource '/api/crime_reports/:id', id: '@id'
		all: ->
			this.service.query()
		delete: (reportid) ->
			this.service.remove(id: reportid)
		create: (params) ->
			this.service.save(params)
		show: (reportid) ->
			this.service.get(id: reportid)
]

# This is an example of a simple data sharing service that two controllers can use to pass
# data around so as to minimize calls to the backend api. This speeds up the app since we
# don't have to use the above class to query for a single data point.
app.factory 'CrimeReportService', -> {
	@report
	setReport: (newReport) ->
		@report = newReport
	getReport: ->
		@report
}

# This factory will connect with the search api to search all crime reports based on the given parameters.
app.factory 'CrimeReportSearch', ['$resource', ($resource) ->
	new class CrimeReportSearch
		constructor: ->
			this.service = $resource '/api/crime_reports/search', params: '@params'
		search: (stuff)->
			# 'get' will not work in this case because it expects a single object, 'query' will return an array.
			this.service.query(stuff)
]