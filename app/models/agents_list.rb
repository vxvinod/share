class AgentsList

	@current_time = Time.now
	
	class << self

		def team_agents_list
	      @current_time = Time.now
	      agents_list=[]
	      begin        
	        get_all_agents_from_api.each do |item|
	          if is_active?(item)  
	            #===Push all the obtained values to the array===
	            agents_list << [agent_name(item),item['AgentStateId'], get_agents_last_seen_time(item, @current_time)]
	          end
	        end
	        agents_list
	      rescue
	        []
	      end
	    end

	    def get_all_agents_from_api
	      #Agent Data Call - Admin_API_v2.0.pdf/Agent List - Page 4/33
	      response = InContactApi::Connection.base.get "/inContactAPI/services/v2.0/agents/states"
	      JSON.parse(response.body)['agentStates']? JSON.parse(response.body)['agentStates']: []
	    end

	    def is_active?(item)
	      (item['AgentStateId']!=0)? true:false
	    end

	    def agent_name(item)
	      item['FirstName']+" "+item['LastName']
	    end

	    def format_agent_time(time_def)
	     mm,ss = time_def.divmod(60)
	     hh,mm = mm.divmod(60)
	     dd,hh = hh.divmod(24)
	     (dd>0)? "%d:%d:%d:%d" % [dd,hh,mm,ss] : ((hh>0)? "%d:%d:%d" % [hh,mm,ss] : ((mm>0)? "%d:%d" % [mm,ss] : "0:%d" % [ss.to_i]))
		end

	    def get_agents_last_seen_time(item, current_time)
	      time_def = current_time - Time.parse(item['LastUpdateTime']).utc
	      format_agent_time(time_def)
	    end

	end
end