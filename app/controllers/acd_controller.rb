class AcdController < ApplicationController
  
  def agent_list
  end	

  def get_agent_list
    
    #Fetch Agents' List
    @agents_list = AgentsList.team_agents_list
    @agents_list.each do |val|
     val[1] = val[1]==1?val[1]='Available':(val[1]==2?'Unavailable':(val[1]==3?'On a Call':(val[1]==4?'Outbound':(val[1]==5?'InConsult':(val[1]==6?'OutConsult':'LoggedOut')))))
    end
    
    #Render Output
    render :partial => "temp_agent_list", :status => 200
  end

end
