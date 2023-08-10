class EventHostsController < ApplicationController

  def new
    @event = current_user.events.friendly.find(params[:event_id])
    @event_host = @event.event_hosts.new
  end

  def create
    @event = current_user.events.friendly.find(params[:event_id])
    @event_host = @event.event_hosts.new(event_host_params)
    @event_host.invite_user
    if @event_host.save
      flash[:now] = "host created"
    end
  end

  def edit
    @event = current_user.events.friendly.find(params[:event_id])
    @event_host = @event.event_hosts.find(params[:id])
  end

  def destroy
    @event = current_user.events.friendly.find(params[:event_id])
    @event_host = @event.event_hosts.find(params[:id])
    if @event_host.destroy
      flash[:now] = "host removed"
    end
  end

  def update
    @event = current_user.events.friendly.find(params[:event_id])
    @event_host = @event.event_hosts.find(params[:id])
    if @event_host.update(event_host_params)
      flash[:now] = "host updated"
    end
  end

  def event_host_params
    params.require(:event_host).permit(
      :email, :name, :description, :listed_on_page, :event_manager, :avatar
    )
  end
end
