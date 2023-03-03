class Answer < ApplicationRecord
  has_many_attached :files

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
end
