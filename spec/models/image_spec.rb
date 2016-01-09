require 'rails_helper'

RSpec.describe Image, type: :model do
  it { is_expected.to belong_to(:person) }

  describe '.classified' do
    specify { expect(described_class.classified.to_sql).to eq described_class.where.not(person: nil).to_sql }
  end
end
