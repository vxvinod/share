module ModelFunctions

	#To format the seconds time into proper format
	def format_agent_time(time_def)
		mm,ss = time_def.divmod(60)
		hh,mm = mm.divmod(60)
		dd,hh = hh.divmod(24)
		(dd>0)? "%d:%d:%d:%d" % [dd,hh,mm,ss] : ((hh>0)? "%d:%d:%d" % [hh,mm,ss] : ((mm>0)? "%d:%d" % [mm,ss] : "0:%d" % [ss.to_i]))
	end

	#Get average values of past hour
	def past_hour
  		response = self.where({created_at: (Time.now.utc - 1.hour)..Time.now.utc})

	  	#Empty Attributes Array
	  	attrib = []

		#Find all the attributes of the Active Record resultset
		response.accessible_attributes.each do |value|
			if value!=""
				attrib << value
			end
		end

		#Now add the average of all the values to the 0th element of resultset
		attrib.each do |value|
		  response[0][value]=(response[0][value])/response.length
		end
		for i in 1..response.length-1
			attrib.each do |value|
		      response[0][value]+=(response[i][value])/response.length
		   end
		end

		json_response = response[0].as_json
		json_response['AbandonRate']=json_response['AbandonRate'].round(1)
	    json_response['LongestQueueDur']=format_agent_time(json_response['LongestQueueDur'])
	    json_response['AverageWrapTime']=format_agent_time(json_response['AverageWrapTime'])
	    json_response['AverageSpeedToAnswer']=format_agent_time(json_response['AverageSpeedToAnswer'])
	    json_response['AverageTalkTime']=format_agent_time(json_response['AverageTalkTime'])

	    #Return Value
	    json_response
  	end
  	
end