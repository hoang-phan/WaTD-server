require 'rails_helper'

RSpec.describe Person, type: :model do
  it { is_expected.to validate_length_of(:name).is_at_most(MAX_LENGTH_PERSON_NAME) }
  it { is_expected.to have_many(:images) }
end
