require 'rails_helper'

RSpec.describe Wine, type: :model do
  describe '仮想属性の挙動' do
    it 'price_rangeに値を設定・取得できる' do
      wine = Wine.new
      wine.price_range = '1000〜2000円'
      expect(wine.price_range).to eq('1000〜2000円')
    end
  end

  describe 'バリデーション（将来的に追加する場合）' do
    it 'price_rangeがnilでも有効（バリデーションなしの場合）' do
      wine = Wine.new
      wine.price_range = nil
      expect(wine).to be_valid
    end

    context 'presence: true を付けた場合' do
      before do
        class WineWithValidation < Wine
          validates :price_range, presence: true
        end
      end

      it 'price_rangeが空なら無効' do
        wine = WineWithValidation.new(price_range: nil)
        expect(wine).not_to be_valid
        expect(wine.errors[:price_range]).to include("can't be blank")
      end

      it 'price_rangeがあれば有効' do
        wine = WineWithValidation.new(price_range: '1000〜2000円')
        expect(wine).to be_valid
      end
    end
  end
end