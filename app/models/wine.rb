class Wine < ApplicationRecord
    attr_accessor :price_range
    has_many :suggestions, dependent: :destroy
    # 必要ならバリデーションも可能（保存されないけどフォームでチェックできる）
    # validates :price_range, presence: true
  end
  
