require 'rails_helper'

describe Recognizer do
  describe '#perform' do
    let!(:test_image) { create(:image, data: File.read(Rails.root.join('spec', 'fixtures', 'obama.jpg'))) }

    after do
      subject.perform(test_image.id)
    end

    context 'has no previous classified images' do
      it 'returns id 0 and confidence 0' do
        expect(subject).to receive(:send_push_message).with(0, 0)
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
        expect(subject).to receive(:send_push_message).with(sample_image_1.id, anything)
      end
    end
  end
end
