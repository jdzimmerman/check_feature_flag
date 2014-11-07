require 'sinatra'
require 'slim'
require 'rubygems'
require 'json'
require 'httparty'


BASE_URL="http://stlb-001.sjc1.sendgrid.net:8082/api/feature_toggle/check.json"
#flag_names = ["send_campaign","LIST_UPLOAD_THREADING","query_locks","recipient_lists"]
#flags = Hash.new

def check_flag(fname)
	url = "#{BASE_URL}?feature_name=#{fname}&app_name=nlvx"
	json_str = HTTParty.get(url).body
	flag_status = JSON.parse(json_str)
	return flag_status["enabled"]
end

get '/' do
   @title = "Feature Flag Status in Staging"
  @flag_names = ["send_campaign","LIST_UPLOAD_THREADING","query_locks","recipient_lists","campaign_pause_play","overview_stats"]
  @flags = Hash.new
  @flag_names.each do |f| 
	status = check_flag(f)
	@flags.store(f,status)
  end

  erb :index
end

