json.array!(@crime_reports) do |crime_report|
  json.extract! crime_report, :id, :user, :body, :address, :latitude, :longitude
  json.url crime_report_url(crime_report, format: :json)
end
