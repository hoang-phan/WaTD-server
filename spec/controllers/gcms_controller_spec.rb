require 'rails_helper'

describe GcmsController, type: :controller do
  describe 'POST create' do
    let(:params) do
      {
        device_id: device_id,
        reg_id: reg_id
      }
    end

    let(:device_id) { Faker::Lorem.word }
    let(:reg_id) { Faker::Lorem.word }
    let(:new_device) { Device.last }

    context 'device not exist' do
      it 'creates new device' do
        expect {
          post :create, params
        }.to change(Device, :count).by 1

        expect(new_device.device_id).to eq device_id
        expect(new_device.reg_id).to eq reg_id
      end
    end

    context 'device not exist' do
      let!(:device) { create(:device, device_id: device_id) }
      it 'creates new device' do
        expect {
          post :create, params
        }.not_to change(Device, :count)

        expect(device.reload.reg_id).to eq reg_id
      end
    end
  end
end
