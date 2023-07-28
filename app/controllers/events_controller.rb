class EventsController < ApplicationController

  def index
    @upcoming_events = Event.upcoming_events
    @past_events = Event.past_events
  end

  def new
    @event = current_user.events.new
  end

  def show
    @event = current_user.events.friendly.find(params[:id])
  end

  def edit
    @section = params[:section]
    @event = current_user.events.friendly.find(params[:id])
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:now] = "yes!"
      redirect_to edit_event_path(@event)
    end
  end

  def update
    @section = params[:section]
    @event = current_user.events.friendly.find(params[:id])

    if params[:toggle_published].present?
      @event.toggle_published!
      flash[:now] = "event #{@event.state}"
      render "toggle_published" and return
    end

    if @event.update(event_params)
      flash[:now] = "yes!"
      #redirect_to edit_event_path(@event, section: @section)
    end
  end

  def mine
    @tab = params[:tab] || "drafts"
    case @tab
    when "all"
      @events = current_user.events.page(params[:page]).per(10)
    when "drafts"
      @events = current_user.events.drafts.page(params[:page]).per(10)
    when "published"
      @events = current_user.events.published.page(params[:page]).per(10)
    when "manager"
      @events = Event.joins(:event_hosts)
      .where(event_hosts: { user_id: current_user.id })
      .includes(:user)
      .page(params[:page]).per(10)
    else
      @events = current_user.events.page(params[:page]).per(10)
    end
  end


  private

  def event_params
    params.require(:event).permit(:title, :event_start, :event_ends, 
      :description, :venue, :age_requirement, :payment_gateway, 
      :ticket_currency, :location, :lat, :lng, :country, :city, :province, 
      :participant_label, :participant_description, :scheduling_label, 
      :scheduling_description,
      
      event_schedules_attributes: [
        :id, :name, :_destroy, :start_date, :end_date, :schedule_type, :description,
        schedule_schedulings_attributes: [:id, :_destroy, :name, :start_date, :end_date, :short_description]
      ],
      event_tickets_attributes: [
        :id,
        :title, :_destroy, :show_sell_until, 
        :price, :qty, :selling_start, :selling_end, :short_description,
        :show_after_sold_out, :hidden, :min_tickets_per_order, 
        :max_tickets_per_order, :after_purchase_message, 
        :sales_channel
      ])
  end
end
