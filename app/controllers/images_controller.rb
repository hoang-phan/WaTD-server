class ImagesController < ApplicationController
  def create
    image = Image.create(image_params)
    render json: { success: true }
  end

  private

  def image_params
    params.require(:image).permit(:data)
  end
end