class TicketsController < ApplicationController
  before_action :set_s3_direct_post
  expose :tickets, ->{current_company.tickets}
  expose :ticket, scope: ->{tickets}
  skip_load_and_authorize_resource
  # GET /tickets
  # GET /tickets.json
  def index
    respond_to do |format|
      format.html
      format.json { render json: TicketDatatable.new(params, view_context: view_context, collection: tickets), status: 200}
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
  end

  # GET /tickets/1/edit
  def edit

  end

  # POST /tickets
  # POST /tickets.json
  def create
    ticket = current_user.tickets.new(ticket_params)
    ticket.current_user = current_user
    respond_to do |format|
      if ticket.save
        format.html { redirect_to ticket, notice: 'Ticket registrado con éxito.' }
        format.json { render :show, status: :created, location: ticket }
      else
        pp ticket.errors
        format.html { render :new }
        format.json { render json: ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      ticket.current_user = current_user
      if ticket.update(ticket_params)
        format.html { redirect_to ticket, notice: 'Ticket actualizado.' }
        format.json { render :show, status: :ok, location: ticket }
      else
        format.html { render :edit }
        format.json { render json: ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def start
    ticket.init_date = Time.now
    ticket.state = 'started'
    ticket.current_user = current_user
    respond_to do |format|
      if ticket.save
        format.html { redirect_to ticket, notice: 'Ticket iniciado con éxito.' }
        format.json { render :show, status: :created, location: ticket }
      else
        pp ticket.errors
        format.html { render :new }
        format.json { render json: ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish
    ticket.finish_date = Time.now
    ticket.state = 'finished'
    ticket.current_user = current_user
    respond_to do |format|
      if ticket.save
        format.html { redirect_to ticket, notice: 'Ticket finalizado con éxito.' }
        format.json { render :show, status: :created, location: ticket }
      else
        pp ticket.errors
        format.html { render :new }
        format.json { render json: ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    ticket.current_user = current_user
    ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket eliminado.' }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:title, :body, :priority, :classification, :function_points, :init_date, :finish_date, :file, :state, :state_changed_by, :area, :attachment, comments_attributes: [:id, :body, :_destroy])
    end
end
