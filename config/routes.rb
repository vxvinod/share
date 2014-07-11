NewAcd::Application.routes.draw do

  get "skills/skill_table"

  get "acd/agent_list"

  #Remote URL to fetch Skills
  match "skills/full_skill_summary", to: "skills#full_skill_summary"

  #Remote URL to fetch Agents' list
  match "acd/get_agent_list", to: "acd#get_agent_list"

  #Remote URL to fix Threshold Values
  match "skills/edit_threshold_value", to: "skills#edit_threshold_value"

  #Remote URL to set Desktop Notifications
  match "skills/edit_desktop_notifications", to: "skills#edit_desktop_notifications"

  match "agents_list", to: "acd#agent_list"
  match "skill_summary", to: "skills#skill_table"

  root :to => 'skills#skill_table'

end
