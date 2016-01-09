require 'opencv'

class Recognizer
  include Sidekiq::Worker
  include OpenCV

  def perform(image_id)
    if test_image = Image.find_by_id(image_id)
      recognize(image_id, build_samples, test_image.data)
    end
  end

  private

  def recognize(image_id, samples, data)
    id, distance = 0, 0
    if samples[0].present?
      recognizer = LBPH.new
      recognizer.train(*samples)
      id, distance = recognizer.predict(CvMat.decode_image(data, CV_LOAD_IMAGE_GRAYSCALE))
    end
    send_push_message(image_id, id, distance)
  end

  def send_push_message(image_id, id, distance)
    name = 'Unrecognized person'
    if id != 0
      name = Image.find_by_id(id).try(:person).try(:name)
    end
    
    if (reg_ids = Device.pluck(:reg_id)).present?
      $gcm.send(Device.pluck(:reg_id), { data: { id: image_id, name: name, distance: distance }, collapse_key: 'Recognizer' } )
    end
  end

  def build_samples
    datas, labels = [], []

    Image.classified.find_each do |image|
      datas << CvMat.decode_image(image.data, CV_LOAD_IMAGE_GRAYSCALE)
      labels << image.id
    end

    [datas, labels]
  end
end
