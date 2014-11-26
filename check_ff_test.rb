require 'rubygems'
require 'json'
require 'httparty'

if ARGV[0] == "local"
	hostname = "0.0.0.0"
elsif ARGV[0] == "prod"
	hostname = "lbapi-002.sjc1.sendgrid.net"	
else
	hostname = "stlb-001.sjc1.sendgrid.net" 
end

BASE_URL="http://#{hostname}:8082/api/feature_toggle/check.json"
#puts BASE_URL

flags = ["send_campaign","LIST_UPLOAD_THREADING","query_locks","recipient_lists","campaign_pause_play","overview_stats"]
def check_flag(fname)
	url = "#{BASE_URL}?feature_name=#{fname}&app_name=nlvx"
	json_str = HTTParty.get(url).body
	flag_status = JSON.parse(json_str)
    return flag_status["enabled"]
end

#error handling if connection fails
begin
	#hcheck_resp = HTTParty.get("http://#{hostname}:8082/api/healthcheck/alive.json")
	flags.each do |f|
	   print "#{f}:  "
	   puts check_flag(f)
    end
#rescue Exception => e
rescue Errno::ECONNREFUSED => e
	print e.message 
	puts " This means APID is not running, or port forwarding may not be working in your local environment" 
end
