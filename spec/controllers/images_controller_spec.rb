require 'rails_helper'

describe ImagesController, type: :controller do
  describe 'POST create' do
    let(:params) do
      {
        image: {
          data: data
        }
      }
    end

    let(:data) { Faker::Lorem.word }
    let(:image) { Image.last }

    it 'creates new image' do
      expect(Recognizer).to receive(:perform_async).with(anything)
      expect {
        post :create, params
      }.to change(Image, :count).by 1

      expect(image.data).to eq data
    end
  end

  describe 'GET show' do
    let!(:image) { create(:image) }

    after do
      get :show, id: image.id
    end

    it 'sends image data' do
      expect(controller).to receive(:send_data)
        .with(image.data, type: 'image/jpg', disposition: 'inline'){ controller.render nothing: true }
    end
  end

  describe 'PUT update' do
    let(:params) do
      {
        name: name,
        id: image.id
      }
    end

    let(:name) { Faker::Name.name }
    let(:image) { create(:image) }

    before do
      put :update, params
    end

    it 'updates image\' owner name' do
      expect(image.reload.person.name).to eq name
    end
  end
end
