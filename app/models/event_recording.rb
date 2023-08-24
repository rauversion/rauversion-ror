class EventRecording < ApplicationRecord
  belongs_to :event

  self.inheritance_column = :_type_disabled
end
