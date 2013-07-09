require 'active_broken_record/rails_subscriber'

module ActiveBrokenRecord
  class Railtie < Rails::Railtie
    initializer "active_broken_record.configure_rails_initialization" do
      rails_subscriber = ActiveBrokenRecord::RailsSubscriber.new
      ActiveSupport::Notifications.subscribe("sql.active_record", rails_subscriber.callback(:sql))
      ActiveSupport::Notifications.subscribe("start_processing.action_controller", rails_subscriber.callback(:start_recording))
      ActiveSupport::Notifications.subscribe("process_action.action_controller", rails_subscriber.callback(:finish_recording))
    end
  end
end