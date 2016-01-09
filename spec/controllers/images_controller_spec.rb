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

    it 'creates new images' do
      expect {
        post :create, params
      }.to change(Image, :count).by 1

      expect(image.data).to eq data
    end
  end
end