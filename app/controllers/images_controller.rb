class ImagesController < ApplicationController
  def create
    image = Image.create(image_params)
    Recognizer.perform_async(image.id)
    render json: { success: true }
  end

  private

  def image_params
    params.require(:image).permit(:data)
  end
end
