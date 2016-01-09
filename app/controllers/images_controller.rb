class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :update]

  def create
    image = Image.create(image_params)
    Recognizer.perform_async(image.id)
    render json: { success: 'true' }
  end

  def show
    send_data @image.data, type: 'image/jpg', disposition: 'inline'
  end

  def update
    person = @image.person || Person.new
    person.name = params[:name]
    @image.update(person: person)
    render json: { success: 'true' }
  end

  private

  def image_params
    params.require(:image).permit(:data)
  end

  def set_image
    @image = Image.find(params[:id])
  end
end
