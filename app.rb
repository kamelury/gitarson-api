require 'sinatra'
require "net/https"
require "uri"
require 'json'

get '/:user' do
	user = params[:user]
	status 404 and return unless user
	
	#fetch data from github.com
	uri = URI.parse("https://api.github.com/users/#{user}/events")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	request = Net::HTTP::Get.new(uri.request_uri)
	response = http.request(request)
	data = []

	#filter pullrequest events and repos
	if response.code == "200"
		events_json = JSON.parse(response.body)

		data = events_json.map do |e| 
			e['payload']['pull_request'] if e['type'] == "PullRequestEvent" and !e['repo']['name'].start_with?(user) 
		end.compact
	end

	content_type :json
	result = {}
	result['data'] = data
	result["message"] =  response.message
	result["code"] = response.code
	result.to_json
end

