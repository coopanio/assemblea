# frozen_string_literal: true

class ConsultationsController < ApplicationController
  include FlashConcern

  def new
    @consultation = Consultation.new
  end

  def create
    @consultation = Consultation.new(create_params)
    token = Token.new(role: :admin, consultation: @consultation)
    manager_token = nil

    @consultation.transaction do
      @consultation.save!
      token.save!

      if @consultation.config.synchronous?
        event = Event.create(title: 'Default', consultation: @consultation)
        manager_token = Token.create(role: :manager, consultation: @consultation, event: event)
      end
    end

    reset_session
    session[:token] = token.id

    message = [
      "Consulta creada.",
      "L'identificador d'administració és <strong>#{token}</strong>."
    ]
    message << "L'identificador de gestió és <strong>#{manager_token}</strong>." if manager_token.present?
    success(message.join(' '))

    redirect_to action: 'edit', id: @consultation.id
  end

  def edit
    authorize consultation
  end

  def update
    authorize consultation
    consultation.update!(update_params)

    redirect_to action: 'edit', id: @consultation.id
  end

  def show
    authorize consultation
  end

  def destroy
    authorize consultation
    consultation.destroy!

    reset_session
    redirect_to controller: 'main', action: 'index'
  end

  private

  def create_params
    params.require(:consultation).permit(:title, :description)
  end

  def update_params
    params.require(:consultation).permit(:title, :description, :status)
  end

  def consultation
    @consultation ||= policy_scope(Consultation).find(params[:id])
  end
end
