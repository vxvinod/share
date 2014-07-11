class SkillSummary

  @current_time = Time.now

  class << self

    #To format the seconds time into proper format
    def format_agent_time(time_def)
      mm,ss = time_def.divmod(60)
      hh,mm = mm.divmod(60)
      dd,hh = hh.divmod(24)
      (dd>0)? "%d:%d:%d:%d" % [dd,hh,mm,ss] : ((hh>0)? "%d:%d:%d" % [hh,mm,ss] : ((mm>0)? "%d:%d" % [mm,ss] : "0:%d" % [ss.to_i]))
    end

    #For fetching skill type data
    def fetch_skill_data (skill_id,timediff)
      @current_time = Time.now
      #response = JSON.parse((InContactApi::Connection.base.get "/inContactAPI/services/v2.0/skills/"+skill_id.to_s+"/summary?startDate="+ (@current_time-timediff).utc.iso8601 + "&endDate=" + @current_time.utc.iso8601).body)['skillSummaries'].first
      full_response = JSON.parse((InContactApi::Connection.base.get "/inContactAPI/services/v2.0/skills/summary?startDate="+ (@current_time-timediff).utc.iso8601 + "&endDate=" + @current_time.utc.iso8601).body)['skillSummaries']
      File.open("newtest.json","w+"){|f| f.write(full_response)}
      @full_data = full_response
      full_response_length = full_response.length.to_i
      response = {}
       #get response for Sales Department alone using sales id
      (0...full_response_length).each do |resp| 
        response = (full_response[resp]['SkillId'].to_i === skill_id.to_i) ? full_response[resp] : "do nothing"
        (response != "do nothing") ? break : next
      end
      if (skill_id == 122099)
        other_sales_depts = ["122125","122100","147347","134509"] 
        other_sales_depts.each do |dept_skill_id|
          (0...full_response_length).each do |resp|
            #actual_response = (dept_response[resp]['SkillId'].to_i === dept_skill_id.to_i) ? dept_response[resp] : "nothing found"
            actual_response = (full_response[resp]['SkillId'].to_i === dept_skill_id.to_i) ? ((full_response[resp]) ? append_values(response,full_response[resp]) : false) : "nothing found"
            (actual_response != "do nothing") ? break : next
          end
        end 
      
      #Caching Sales values in database
        Sale.create(:QueueCount => response["QueueCount"],:AbandonRate => response["AbandonRate"],:AgentsWorking => response["AgentsWorking"],:AgentsUnavailable => response["AgentsUnavailable"],:LongestQueueDur => response["LongestQueueDur"],:AverageWrapTime => response["AverageWrapTime"],:AverageSpeedToAnswer => response["AverageSpeedToAnswer"],:AverageTalkTime => response["AverageTalkTime"])
      #Service Department
      else
        other_service_depts = ["122133","134577"] #['Service Support','Printed']
         other_service_depts.each do |dept_skill_id|
          (0...full_response_length).each do |resp|
            actual_response = (full_response[resp]['SkillId'].to_i === dept_skill_id.to_i) ? ((full_response[resp]) ? append_values(response,full_response[resp]) : false) : "nothing found"
            (actual_response != "do nothing") ? break : next
          end
        end  
        #Caching Service values in database
        Service.create(:QueueCount => response["QueueCount"],:AbandonRate => response["AbandonRate"],:AgentsWorking => response["AgentsWorking"],:AgentsUnavailable => response["AgentsUnavailable"],:LongestQueueDur => response["LongestQueueDur"],:AverageWrapTime => response["AverageWrapTime"],:AverageSpeedToAnswer => response["AverageSpeedToAnswer"],:AverageTalkTime => response["AverageTalkTime"])
      end
      response['LongestQueueDur']=format_agent_time(response['LongestQueueDur'])
      response['AverageWrapTime']=format_agent_time(response['AverageWrapTime'])
      response['AverageSpeedToAnswer']=format_agent_time(response['AverageSpeedToAnswer'])
      response['AverageTalkTime']=format_agent_time(response['AverageTalkTime'])
      response
    end

    #Sub function => to append values
    def append_values(response,dept_response)
      response['QueueCount']+=dept_response['QueueCount']
      response['AbandonCount']+=dept_response['AbandonRate']
      response['AgentsWorking']+=dept_response['AgentsWorking']
      response['AgentsUnavailable']+=dept_response['AgentsUnavailable']
      response['LongestQueueDur']+=dept_response['LongestQueueDur']
      response['AverageWrapTime']+=dept_response['AverageWrapTime']
      response['AverageSpeedToAnswer']+=dept_response['AverageSpeedToAnswer']
      response['AverageTalkTime']+=dept_response['AverageTalkTime']
      response
    end

    #Queue Counter Values
    def queue_counter
      depts = [2,45,1,36] # In the order ['Marketing-28','Sales-2','Sales Support-45','Service-1','Service Support-36','Television-52','Yellow Page-3']
      queue_counter_data = []
      puts "inside queue counter"
      puts @full_data
      puts "inside queue counter last"
      full_data = @full_data
      #full_data = JSON.parse((InContactApi::Connection.base.get "/inContactAPI/services/v2.0/skills/summary?startDate="+(@current_time-86400).utc.iso8601+"&endDate="+@current_time.utc.iso8601).body)['skillSummaries']
      depts.each do |dept|
        queue_counter_data << {'name' => full_data[dept]['SkillName'], 'incoming' => full_data[dept]['ContactsQueued'], 'abandon' => full_data[dept]['AbandonCount'], 'abandon_percent' => full_data[dept]['AbandonRate'] }
      end
      queue_counter_data
    end    

  end
end