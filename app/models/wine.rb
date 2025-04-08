class Wine < ApplicationRecord
    attr_accessor :price_range
  
    # 必要ならバリデーションも可能（保存されないけどフォームでチェックできる）
    # validates :price_range, presence: true
  end
  
