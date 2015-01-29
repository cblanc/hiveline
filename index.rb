#!/usr/bin/ruby

require 'optparse'
require 'httparty'
require'json'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-u", "--username", "Login username") do |p|
    options[:password] = v
  end

  opts.on("-p", "--password", "Login password") do |p|
    options[:password] = p
  end
end.parse!


username = options[:username] || ENV["HIVE_USERNAME"]

if username.nil?
	print "Please provide a username with a flag (-u) or as an environment variable exports HIVE_USERNAME=\"your_username\"\n"
	exit false
end

password = options[:password] || ENV["HIVE_PASSWORD"]

if password.nil?
	print "Please provide a password with a flag (-p) or as an environment variable exports HIVE_PASSWORD=\"your_password\"\n"
	exit false
end

temp = ARGV.last

def numeric?(number)
  return true if number =~ /^\d+$/
  true if Float(number) rescue false
end

if temp.nil? or !numeric?(temp)
	print "Please supply a temperature. E.g. hiveline 21\n"
	exit false
else
	temp = temp.to_i
end

# Login with credentials and return cookie

def login(username, password)
	print "Authenticating credentials...\n"
	login_url = "https://my.hivehome.com/login"
	HTTParty.post(login_url, {
		body: {
			username: username,
			password: password
		}, 
		follow_redirects: false
	})
end

def extract_id(response)
	id_attribute_regex = /^hsid=/
	set_cookie_header = response.headers["set-cookie"]
	set_cookie_header
		.split(";")
		.each(&:strip!)
		.grep(id_attribute_regex)
		.first
		.gsub(id_attribute_regex, "")
end

def get_id(username, password)
	extract_id login(username, password)
end

def set_temperature(id, temp)
	print "Setting temperature to #{temp}C...\n"
	heating_url = "https://my.hivehome.com/heating/target"
	response = HTTParty.put(heating_url, {
		body: {
			id:1,
			target:temp
		},
		headers: {
			"Cookie" => "hsid=#{id}"
		},
		follow_redirects: false
	})

	if response.code == 200
		target = JSON.parse(response.body)["target"]
		print "Successfully updated temperature. Set to #{target}C\n"
	else
		print "Something went wrong. Not sure what, maybe get up and go check your thermostat?\n"
	end
	response
end

id = get_id(username, password)
set_temperature(id, temp)