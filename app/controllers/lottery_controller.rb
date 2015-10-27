# encoding:utf-8
class LotteryController < ApplicationController
	
	require 'net/http'
	require 'json'
	require 'rubygems'
	require 'digest/md5'
	
	def status
		if request.get?
			# byte[] bytes = user.phone.getBytes();
   #     for (int i = 0; i < bytes.length; i++) {
   #         bytes[i] = (byte) (bytes[i] + 2*i + 20);
   ##     }
   #			phone = '65584512'.bytes.to_a
   #			new = []
   #			phone.each_with_index do |element,index|
  	# 			new[index] = element + 2*index + 20
  				
			# end
			
			# puts new.pack('c*')
			
			# @uc = '1-68;A@DCG'
			# @ti = '1'
			# @signature = "goodview"
			# @terminalId = "cc01187c-1be4-4a6d-be6c-5bb52855a24b"
			# @uCode = "17"
			
			@uc = params[:uc]
			@ti = params[:ti]
			@signature = params[:signature]
			@terminalId = params[:terminalId]
			@uCode = params[:uCode]
			@json = JSON.generate({:uc => @uc})
                
			url = 'http://112.74.104.67/gvhappymacau/raffle/ispass'
	       
	       	body = my_post(url,@uCode,@json,@terminalId,@signature)
	       	
			msg = JSON.parse(body)["msg"]
			

			if msg == 'msg22'
				@type = 1
				@last = '1445842328000'
			elsif msg == 'msg23'
				@type = 0
				#@last = JSON.parse(body)["returnObject"]["object"]
				
			elsif msg == 'msg24'
				@type = 2
			elsif msg == 'msg99'
				render :text => '打開方式有誤,請用不夜城掃描打開'
			elsif msg == 'msg98'
				render :text => '敏哥哥在更新服務器'
			elsif msg == 'msg97'
				render :text => '代理服務器大姨媽，請找敏哥哥'
			else 
				render :text => '你的帳號有問題，請去112.74.104.67的不夜城註冊'
			end
			
		end
	end
	

	def signal
		
		url = 'http://112.74.104.67/gvhappymacau/raffle/start'
	    body = my_post(url,
	    params[:uCode],
	    JSON.generate({:uc => params[:uc],:ti => '1'}),
	    params[:terminalId],
	    params[:signature])
		
		msg = JSON.parse(body)["msg"]
		if msg == "msg22" 
			render text: 1
		elsif msg == 'msg23'
			render text: 0
		elsif msg == 'msg21'
			render text: 99
		end
		
		
	
	end
	
	def my_post(url,uCode,json,terminalId,signature)
		if(uCode.blank? || terminalId.blank? || signature.blank? || json.blank?) then
			return '{"msg":"msg99"}'
		end
			
		timestamp = DateTime.now.strftime("%Q")
    	a = Digest::MD5.hexdigest(signature + json);
		b = Digest::MD5.hexdigest(terminalId + timestamp);
		c = Digest::MD5.hexdigest(timestamp + json);
		
		a1 = a[4..9]
		a2 = a[15..17]
		a3 = a[24..28]
		b1 = b[8..14]
		b2 = b[16..26]
		c1 = c[6..8]
		c2 = c[12..22]
		d = Digest::MD5.hexdigest(a1 + b2 + a3);
		e = Digest::MD5.hexdigest(a2 + c2);
		f = Digest::MD5.hexdigest(a1 + b2 +a2 +c1 +b1 +c2);
		encryptedJson = d[3..12] + d[20..25] + e[11..16] + e[27..31] + f[7..9] + f[21..22]
	    
	    uri = URI(url)
	    res = Net::HTTP.post_form(uri,
	        'json' => json,
	        'signature' => signature,
	        'timestamp' => timestamp,
	        'terminalId' => terminalId,
	        'uCode' => uCode,
	        'encryptedJson' => encryptedJson)
	        
        puts 'response body ===== ' + res.body
        if(res.body.include? 'Apache')
        	return '{"msg":"msg98"}'
        end
        if(res.body.include? 'nginx')
        	return '{"msg":"msg97"}'
        end
	   	return res.body
	
	end
end
