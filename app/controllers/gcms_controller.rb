class GcmsController < ApplicationController
  def create
    device = Device.find_or_create_by(device_id: params[:device_id])
    device.reg_id = params[:reg_id]
    device.save
    render json: { success: 'true' }
  end
end
