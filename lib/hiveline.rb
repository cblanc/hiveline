#!/usr/bin/ruby

require 'httparty'
require'json'

class HiveClient
	attr_accessor :username, :password, :hive_id

	def initialize(username, password)
		@username = username
		@password = password
		@id = retrieve_session
	end

	def set_temperature(temp)
		print "Setting temperature to #{temp}C...\n"
		heating_url = "https://my.hivehome.com/heating/target"
		response = HTTParty.put(heating_url, {
			body: {
				id:1,
				target:temp
			},
			headers: {
				"Cookie" => "hsid=#{@id}"
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

	private

	def login
		print "Authenticating credentials...\n"
		login_url = "https://my.hivehome.com/login"
		HTTParty.post(login_url, {
			body: {
				username: @username,
				password: @password
			}, 
			follow_redirects: false
		})
	end

	def extract_session_id(response)
		id_attribute_regex = /^hsid=/
		set_cookie_header = response.headers["set-cookie"]
		set_cookie_header
			.split(";")
			.each(&:strip!)
			.grep(id_attribute_regex)
			.first
			.gsub(id_attribute_regex, "")
	end

	def retrieve_session
		extract_session_id login
	end
end
