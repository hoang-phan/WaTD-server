require 'rails_helper'

describe Recognizer do
  describe '#perform' do
    let!(:test_image) { create(:image, data: File.read(Rails.root.join('spec', 'fixtures', 'obama.jpg'))) }

    after do
      subject.perform(test_image.id)
    end

    context 'has no previous classified images' do
      it 'returns id 0 and confidence 0' do
        expect(subject).to receive(:send_push_message).with(test_image.id, 0, 0)
      end
    end

    context 'has previous classified images' do
      let(:person_1) { create(:person) }
      let(:person_2) { create(:person) }
      let!(:sample_image_1) do
        create(:image,
          data: File.read(Rails.root.join('spec', 'fixtures', 'obama.jpg')),
          person: person_1
        )
      end

      let!(:sample_image_2) do
        create(:image,
          data: File.read(Rails.root.join('spec', 'fixtures', 'bush.jpg')),
          person: person_2
        )
      end

      it 'returns correct id' do
        expect(subject).to receive(:send_push_message).with(test_image.id, sample_image_1.id, anything)
      end
    end
  end

  describe '#send_push_message' do
    let!(:device) { create(:device) }
    let(:distance) { 5 }
    let(:image_id) { 3 }

    after do
      subject.send(:send_push_message, image_id, id, distance)
    end

    context 'id is not 0' do
      let!(:image) { create(:image, person: person) }
      let!(:person) { create(:person) }
      let(:id) { image.id }
      
      it 'sends name to devices' do
        expect($gcm).to receive(:send).with(
          [device.reg_id],
          {
            data: {
              id: image_id,
              name: person.name,
              distance: distance
            },
            collapse_key: 'Recognizer'
          }
        )
      end
    end

    context 'id is 0' do
      let(:id) { 0 }

      it 'sends Unrecognized person to devices' do
        expect($gcm).to receive(:send).with(
          [device.reg_id],
          {
            data: {
              id: image_id,
              name: 'Unrecognized person',
              distance: distance
            },
            collapse_key: 'Recognizer'
          }
        )
      end
    end
  end
end
