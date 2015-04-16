class Api::V1::ApiController < ApiController
  skip_before_action :verify_authenticity_token
end
