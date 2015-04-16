class Api::V1::AuthController < Api::V1::ApiController
  def stream
    valid = User.valid_stream_key?(params[:name], params[:stream_key])
    require 'pry'; binding.pry
    respond_to do |format|
      if valid
        format.json { render json: {auth:'ok'}, status: 200 }
      else
        format.json { render json: {auth:'fail'}, status: 401 }
      end
    end
  end
end
