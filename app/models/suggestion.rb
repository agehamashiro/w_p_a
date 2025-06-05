class Suggestion < ApplicationRecord
  belongs_to :wine
  has_many :reviews, dependent: :destroy  # 追加
end
