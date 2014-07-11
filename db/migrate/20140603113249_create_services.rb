class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :QueueCount
      t.float :AbandonRate
      t.integer :AgentsWorking
      t.integer :AgentsUnavailable
      t.float :LongestQueueDur
      t.float :AverageWrapTime
      t.float :AverageSpeedToAnswer
      t.float :AverageTalkTime

      t.timestamps
    end
  end
end
