# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :taggings
  has_many :recipes, through: :taggings

  validates :name, presence: true
   uniqueness: { case_sensitive: false }
end
