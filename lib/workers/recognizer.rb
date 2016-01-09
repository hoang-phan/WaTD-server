require 'opencv'

class Recognizer
  include Sidekiq::Worker
  include OpenCV

  def perform(image_id)
    if test_image = Image.find_by_id(image_id)
      recognize(build_samples, test_image.data)
    end
  end

  private

  def recognize(samples, data)
    id, distance = 0, 0
    if samples[0].present?
      recognizer = LBPH.new
      recognizer.train(*samples)
      id, distance = recognizer.predict(CvMat.decode_image(data, CV_LOAD_IMAGE_GRAYSCALE))
    end
    send_push_message(id, distance)
  end

  def send_push_message(id, distance)

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
