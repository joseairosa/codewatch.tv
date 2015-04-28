class Api::V1::ChatController < Api::V1::ApiController

  attr_reader :channel

  before_filter :find_channel
  before_filter :is_authorized

  include ChannelHelper

  def ban
    if @channel
      ChatService.instance.ban(@channel, params[:username])
      response = {json: {auth: 'ok'}, status: 200}
    else
      response = {json: {auth: 'not_found'}, status: 404}
    end

    respond_to do |format|
      format.json { render response }
    end
  end

  def toggle_moderator
    if @channel
      ChatService.instance.toggle_moderator(@channel, params[:username])
      response = {json: {auth: 'ok'}, status: 200}
    else
      response = {json: {auth: 'not_found'}, status: 404}
    end

    respond_to do |format|
      format.json { render response }
    end
  end

  private

  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def is_authorized
    unless current_user && (is_channel_owner? || is_channel_moderator?)
      response = {json: {auth: 'unauthorized'}, status: 401}
      respond_to do |format|
        format.json { render response }
      end
    end
  end
end
