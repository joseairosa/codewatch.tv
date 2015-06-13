class Api::V1::SmilController < Api::V1::ApiController
  def generate
    output =
"""<smil>
  <head>
    <meta base=\"rtmp://streamer.codewatch.tv/watch/\" />
  </head>
  <body>
    <switch>
      <video src=\"flv:#{params[:username]}@720p\" height=\"720\" system-bitrate=\"2000000\" width=\"1280\" />
      <video src=\"flv:#{params[:username]}@320p\" height=\"360\" system-bitrate=\"800000\" width=\"640\" />
      <video src=\"flv:#{params[:username]}@180p\" height=\"180\" system-bitrate=\"300000\" width=\"320\" />
    </switch>
  </body>
</smil>
"""
    respond_to do |format|
      format.text { render text: output, status: 200 }
    end
  end
end
