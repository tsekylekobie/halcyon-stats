class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Insert your API key here
  $api_key;
end
