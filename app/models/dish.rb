class Dish < ApplicationRecord

    validates :name, presence: true
    validates :description, presence: true
    validates :image_url, presence: true

    def to_meta_tags
      {
        title: name,
        description: description.truncate(100),
        image: image_url,
        type: "article",
        url: Rails.application.routes.url_helpers.dish_url(self)
      }
    end
end
