class Api::V1::AuthController < Api::V1::ApiController
  def stream
    valid = User.valid_stream_key?(params[:name], params[:stream_key])
    if valid
      user = User.where(username: params[:name]).first
      if params[:app] == 'stream' && user.record_stream?
        response = {json: {auth: 'ok'}, status: 302, location: "rtmp://127.0.0.1/record/#{params[:name]}?stream_key=#{params[:stream_key]}"}
      else
        response = {json: {auth: 'ok'}, status: 200}
      end
    else
      response = {json: {auth: 'fail'}, status: 401}
    end
    respond_to do |format|
      format.json { render response }
    end
  end
end
