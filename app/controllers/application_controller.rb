class ApplicationController < ActionController::API
  # handles the LineOutOfRangeError with HTTP 413 code
  rescue_from FileReader::LineOutOfRangeError, with: :content_too_large

  def content_too_large
    head :payload_too_large
  end
end
