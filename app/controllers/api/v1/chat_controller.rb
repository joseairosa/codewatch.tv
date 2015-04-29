class Api::V1::ChatController < Api::V1::ApiController

  attr_reader :channel

  before_filter :find_channel
  before_filter :is_authorized

  include ChannelHelper

  def ban
    if @channel
      user = User.where(username: params[:username]).first
      if user
        response = if current_user.id == user.id
                     {json: {response: "Can't ban yourself"}, status: 401}
                   elsif is_channel_owner?(user)
                     {json: {response: "Can't ban channel owner"}, status: 401}
                   elsif !is_channel_owner?(current_user) && is_channel_moderator?(user)
                     {json: {response: "Can't ban other moderators"}, status: 401}
                   else
                     ChatService.instance.ban(@channel, user)
                     {json: {response: "#{user.username} banned"}, status: 200}
                   end
      else
        response = {json: {response: 'User not found'}, status: 404}
      end
    else
      response = {json: {response: 'Channel not found'}, status: 404}
    end

    respond_to { |format| format.json { render response } }
  end

  def toggle_moderator
    if @channel
      user = User.where(username: params[:username]).first
      if user
        response = if current_user.id == user.id
                     {json: {response: "Can't toggle yourself as moderator"}, status: 401}
                   elsif is_channel_owner?(user)
                     {json: {response: "Can't toggle channel owner as moderator"}, status: 401}
                   elsif !is_channel_owner?(current_user) && is_channel_moderator?(user)
                     {json: {response: "Can't toggle other moderators as moderator"}, status: 401}
                   else
                     ChatService.instance.toggle_moderator(@channel, user)
                     if is_channel_moderator?(user)
                       {json: {response: "#{user.username} is now a moderator"}, status: 200}
                     else
                       {json: {response: "#{user.username} is no longer a moderator"}, status: 200}
                     end
                   end
      else
        response = {json: {response: 'User not found'}, status: 404}
      end
    else
      response = {json: {response: 'Channel not found'}, status: 404}
    end

    respond_to { |format| format.json { render response } }
  end

  def remove_message
    if @channel
      user = User.where(username: params[:username]).first
      if user
        response = if is_channel_owner?(user) && is_channel_moderator?(current_user)
                     {json: {response: "Can't remove channel owner messages"}, status: 401}
                   elsif !is_channel_owner?(current_user) && is_channel_moderator?(user)
                     {json: {response: "Can't remove other moderators messages"}, status: 401}
                   else
                     ChatService.instance.remove_message(@channel, params[:message_id])
                     {json: {response: "#{user.username}'s message deleted"}, status: 200}
                   end
      else
        response = {json: {response: 'User not found'}, status: 404}
      end
    else
      response = {json: {response: 'Channel not found'}, status: 404}
    end

    respond_to { |format| format.json { render response } }
  end

  private

  def find_channel
    @channel = Channel.find(params[:channel_id])
  end

  def is_authorized
    unless current_user && (is_channel_owner? || is_channel_moderator?)
      response = {json: {response: 'Unauthorized'}, status: 401}
      respond_to do |format|
        format.json { render response }
      end
    end
  end
end
