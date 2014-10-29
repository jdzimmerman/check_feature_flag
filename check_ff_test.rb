require 'rubygems'
require 'json'
require 'httparty'

BASE_URL="http://stlb-001.sjc1.sendgrid.net:8082/api/feature_toggle/check.json"
flags = ["send_campaign","LIST_UPLOAD_THREADING","query_locks","recipient_lists","campaign_pause_play"]
def check_flag(fname)
	url = "#{BASE_URL}?feature_name=#{fname}&app_name=nlvx"
	json_str = HTTParty.get(url).body
	flag_status = JSON.parse(json_str)
    return flag_status["enabled"]
end

flags.each do |f|
	print "#{f}:  "
	puts check_flag(f)
end