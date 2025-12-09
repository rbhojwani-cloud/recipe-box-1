# == Schema Information
#
# Table name: recipes
#
#  id                :bigint           not null, primary key
#  cook_time_minutes :integer
#  description       :text
#  difficulty        :string
#  favorite          :boolean
#  rating            :integer
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Recipe < ApplicationRecord
  belongs_to :user

  has_many :ingredients, class_name: "Ingredient", foreign_key: "recipe_id", dependent: :destroy
  
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  DIFFICULTIES = ["Easy", "Medium", "Hard"].freeze

  validates :title, presence: true

  validates :difficulty,
            inclusion: { in: DIFFICULTIES },
            allow_nil: true

  validates :rating,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 5
            },
            allow_nil: true

end
