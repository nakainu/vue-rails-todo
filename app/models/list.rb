class List < ApplicationRecord
  has_many :todos
  validates :name,
    presence: true,
    length: { maximum: 30 },
    uniqueness: true
end
