require 'base64'
require 'cgi'
require 'openssl'
require 'json'
require 'digest/md5'
require 'httparty'

class ANX
	include HTTParty
	base_uri 'https://anxpro.com/api/2'

	def initialize(options={})
		@apisecret = Base64.decode64(ENV['access_secret'])
		@apikey = ENV['access_key']
		@currency = ENV['currency']
		@values = 'nonce=' + (Time.now.to_f * 1000).to_i.to_s
	end

	def show_fiat_currency
		@currency
	end

	def method_missing(method_sym, *arguments, &block)
		convert_undercores_to_slashes = method_sym.to_s.gsub('_','/')
		convert_undercores_to_slashes = convert_undercores_to_slashes.to_s.gsub('sendsimple','send_simple') # An exception where theres an underscore
		convert_undercores_to_slashes = convert_undercores_to_slashes.gsub('currencypair', "BTC#{@currency}")
		if arguments.length == 1 then
			if arguments[0].kind_of? Hash
				arguments[0].each {|k,v| @values = "#{@values}&#{k}=#{v}"}
			end
		end
		to_sign = convert_undercores_to_slashes + 0.chr + @values	
		ssl_sign = OpenSSL::HMAC.digest('sha512', @apisecret, to_sign)
		signed = Base64.encode64(ssl_sign).to_s.gsub("\n",'')
		self.class.post('/' + convert_undercores_to_slashes, :body => @values, :headers => {'Content-Type' => "application/x-www-form-urlencoded", 'Rest-Key' => @apikey , 'Rest-Sign' => signed}).to_json
	end
end
