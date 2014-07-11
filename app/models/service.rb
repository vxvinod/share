require 'model_functions'

class Service < ActiveRecord::Base
  attr_accessible :AbandonRate, :AgentsUnavailable, :AgentsWorking, :AverageSpeedToAnswer, :AverageTalkTime, :AverageWrapTime, :LongestQueueDur, :QueueCount
  extend ModelFunctions
end
