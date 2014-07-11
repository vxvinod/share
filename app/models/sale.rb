require 'model_functions'

class Sale < ActiveRecord::Base
  attr_accessible :AbandonRate, :AgentsUnavailable, :AgentsWorking, :AverageSpeedToAnswer, :AverageTalkTime, :AverageWrapTime, :LongestQueueDur, :QueueCount
  extend ModelFunctions
end
