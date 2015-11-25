require 'sinatra'
require 'sinatra/contrib/all' if development?
require 'json'


get '/' do
  @username = params["username"] || ""
  @lines = chatlines.last(10)
  erb :index
end

post '/chat' do
  make_comment({ username: params["username"], message: params["message"] })

  if request.xhr? && params.has_key?("since")
    return [200, {"Content-Type" => "application/json"}, JSON.generate(chatlines.select { |x| x[:timestamp] > params["since"].to_i })]
  end

  redirect to "/?username=#{params["username"]}"
end

def chatlines
  $chatlines ||= []
end

def make_comment(comment)
  comment[:timestamp] = Time.now.to_i
  chatlines << comment if required_parameters_given?
end

def required_parameters_given?
  requirements = %w{username message}
  requirements.all? { |x| params.has_key?(x) }
end

def pretty_timestamp_time(timestamp)
  timezone_offset = Time.zone_offset(Time.now.zone)

  time = Time.parse(DateTime.strptime(timestamp.to_s, '%s').to_s).utc + timezone_offset
  time.strftime("%I:%M:%S%p")
end

