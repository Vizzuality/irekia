class StatusMessageData < ActiveRecord::Base
  belongs_to :status_message

  def publish
    status_message.publish if status_message.present?
  end

end
