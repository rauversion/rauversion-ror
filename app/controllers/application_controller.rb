class ApplicationController < ActionController::Base

  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
    #ActiveStorage::Current.url_options = { protocol: "http://", host: "localhost", port: "3000" }
  end
  
end
