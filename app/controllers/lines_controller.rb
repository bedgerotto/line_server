class LinesController < ApplicationController
  def show
    text = FileReader.new.get(line_number:)

    render json: { text: }, status: :ok
  end

  private

  def line_number
    params[:line_index]
  end
end
