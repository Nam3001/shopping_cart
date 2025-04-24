# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:unit) }
    it { should have_one_attached(:thumbnail) }
  end

  describe 'validations' do
    it { should validate_presence_of(:product_name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:thumbnail) }
    
    it { should validate_comparison_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_comparison_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe '#acceptable_thumbnail' do
    let(:product) { build(:product) }

    context 'when thumbnail is valid' do
      before do
        product.thumbnail.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'valid_image.png')),
          filename: 'valid_image.png',
          content_type: 'image/png'
        )
      end
      it 'is valid' do
        expect(product).to be_valid
      end
    end

    context 'when thumbnail is too big' do 
      before do
        product.thumbnail.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'large_image.jpg')),
          filename: 'large_image.jpg',
          content_type: 'image/jpeg'
        )
        allow(product.thumbnail).to receive(:byte_size).and_return(2.megabytes)
      end

      it 'is invalid' do
        expect(product).not_to be_valid
        expect(product.errors[:thumbnail]).to include('is too big (max 1MB)')
      end
    end

    context 'when thumbnail has wrong content type' do
      before do
        product.thumbnail.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'invalid_file.txt')),
          filename: 'invalid_file.pdf',
          content_type: 'text/plain'
        )
      end

      it 'is invalid' do
        expect(product).not_to be_valid
        expect(product.errors[:thumbnail]).to include('image must be JPG or PNG')
      end
      before do
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:product)).to be_valid
    end
  end
end
