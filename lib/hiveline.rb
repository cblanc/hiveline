require 'hiveline/version'
require 'httparty'
require 'json'

module Hiveline
	class Client
		include HTTParty
		attr_accessor :username, :password, :session_cache

		def initialize(username, password)
			@username = username
			@password = password
		end

		def api_session
			session[:ApiSession]
		end

		def hub_ids
			session[:hubIds]
		end

		def session
			@session_cache ||= get_session
		end

		def set_temperature(temp)
			heating_url = "https://api.hivehome.com/v5/users/#{self.username}/widgets/climate/targetTemperature"
			response = self.class.put(heating_url, {
				body: {
					temperature: temp,
					temperatureUnit: "C"
				},
				headers: {
					"Cookie" => "ApiSession=#{self.api_session}",
				},
				follow_redirects: false
			})
			response.code == 204
		end

		def get_temperature
			weather_url = "https://api.hivehome.com/v5/users/#{self.username}/widgets/temperature"
			response = self.class.get(weather_url, {
				headers: {
					"Cookie" => "ApiSession=#{self.api_session}",
					"Content-Type" => "application/json"
				},
				follow_redirects: false
			})
			if response.code == 200
				JSON.parse(response.body)
			else
				nil
			end
		end

		def get_history
			# Just get the first device, ignore others
			hub_id = hub_ids[0]
			thermostat = get_thermostat hub_id
			thermostat_id = thermostat["id"]
			history_url = "https://api.hivehome.com/v5/users/#{self.username}/widgets/temperature/#{thermostat_id}/history?period=today"
			response = self.class.get(history_url, {
				headers: {
					"Cookie" => "ApiSession=#{self.api_session}",
					"Content-Type" => "application/json"
					},
				follow_redirects: false
			})
			if response.code == 200
				JSON.parse(response.body)
			else
				nil
			end
		end

		def get_devices(hub_id)
			devices_url = "https://api.hivehome.com/v5/users/#{self.username}/hubs/#{hub_id}/devices"
			response = self.class.get(devices_url, {
				headers: {
					"Cookie" => "ApiSession=#{self.api_session}"	
				},
				follow_redirects: false
			})
			if response.code == 200
				JSON.parse(response.body)
			else
				nil
			end
		end

		def get_thermostat(hub_id)
			get_devices(hub_id).select { |device| device["type"] == "HAHVACThermostat" }.pop
		end

		private

		def get_session
			login_url = "https://api.hivehome.com/v5/login"
			response = self.class.post(login_url, {
				body: {
					username: @username,
					password: @password
				}, 
				follow_redirects: false
			})
			JSON.parse(response.body, symbolize_names: true)
		end
	end
end