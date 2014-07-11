class SkillsController < ApplicationController
  
  #Threshold Values
  $service_threshold_value = 8
  $sales_threshold_value = 8
  $desktop_notifications = 0
  
  def skill_table
  end

  def full_skill_summary
    #Sales and Service data
  	@sales_api_data = SkillSummary.fetch_skill_data(122099,86400)
    service_value = Thread.new {
      SkillSummary.fetch_skill_data(122098,86400)
    }
    @service_api_data = service_value.value
    service_value.join

    #Past Hour Values
    @past_sales_api_data = Sale.past_hour
    @past_service_api_data = Service.past_hour
    
    #Fetch Queue Counter
    @queue_counter_data = []
    queue_value = Thread.new{
      SkillSummary.queue_counter
    }
    @queue_counter_data = queue_value.value
    queue_value.join

    render :partial => "temp_skill_summary", :status => 200
  end

  def edit_threshold_value
     $service_threshold_value = params[:service_abandon_threshold].to_i
     $sales_threshold_value = params[:sales_abandon_threshold].to_i
     render :nothing => true, :status => 200
  end

  def edit_desktop_notifications
    $desktop_notifications = params[:desktop_notification_threshold]
    render :nothing => true, status => 200
  end

end
