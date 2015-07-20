class Api::V1::SmilController < Api::V1::ApiController
  def generate
    output =
"""<smil>
  <head>
    <meta base=\"rtmp://streamer.codewatch.tv/watch/\" />
  </head>
  <body>
    <switch>
      <video src=\"flv:#{params[:username]}@1080p\" width=\"1920\" height=\"1080\" system-bitrate=\"1920000\" />
      <video src=\"flv:#{params[:username]}@720p\" width=\"1280\" height=\"720\" system-bitrate=\"960000\" />
      <video src=\"flv:#{params[:username]}@320p\" width=\"640\" height=\"360\" system-bitrate=\"480000\" />
      <video src=\"flv:#{params[:username]}@180p\" width=\"320\" height=\"180\" system-bitrate=\"240000\" />
    </switch>
  </body>
</smil>
"""
    respond_to do |format|
      format.text { render text: output, status: 200 }
    end
  end
end
