class EventStreamingServicesController < ApplicationController

  before_action :authenticate_user!
  
  def show
    @event = current_user.events.find_signed(params[:id])
    @provider = @event.streaming_service["name"]
    @service_klass = StreamingProviders::Service.find_module_by_type(@provider)
    @service = @service_klass.new(@event.streaming_service)
  end

  def new
    @event = current_user.events.friendly.find(params[:event_id])
    @service_klass = StreamingProviders::Service.find_module_by_type(params[:service])
    @service = @service_klass.new
    @service.assign_attributes(@event.streaming_service) if @event.streaming_service["name"] == params[:service]
  end

  def update
    @event = current_user.events.friendly.find(params[:event_id])
    @service_klass = StreamingProviders::Service.find_module_by_type(params[:id])
    @service = @service_klass.new(build_params)
    @event.streaming_service = @service.as_json.merge!(name: @service.name)
    @event.save

    redirect_to edit_event_path(@event, section: :streaming)
  end

  def build_params
    params.require(:streaming_service).permit!
  end
end
