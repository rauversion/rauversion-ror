class EventRecordingsController < ApplicationController

  def new
    @event = current_user.events.friendly.find(params[:event_id])
    @event_recording = @event.event_recordings.new
  end

  def create
    @event = current_user.events.friendly.find(params[:event_id])
    @event_recording = @event.event_recordings.new(event_recording_params)
    if @event_recording.save
      flash[:now] = "recording created"
    end
  end

  def edit
    @event = current_user.events.friendly.find(params[:event_id])
    @event_recording = @event.event_recordings.find(params[:id])
  end

  def destroy
    @event = current_user.events.friendly.find(params[:event_id])
    @event_recording = @event.event_recordings.find(params[:id])
    if @event_recording.destroy
      flash[:now] = "recording removed"
    end
  end

  def update
    @event = current_user.events.friendly.find(params[:event_id])
    @event_recording = @event.event_recordings.find(params[:id])
    if @event_recording.update(event_recording_params)
      flash[:now] = "recording updated"
    end
  end

  def event_recording_params
    params.require(:event_recording).permit(:id, :title, :type, :description, :type, :iframe)
  end
end
