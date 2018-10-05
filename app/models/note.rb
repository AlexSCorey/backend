class Note < ApplicationRecord
  belongs_to :user
  belongs_to :calendar

  validates :text, length: { minimum: 1 }, presence: true
  validate :date_format_valid

  private

  def date_format_valid
    unless date
      errors.add(:date, "date format could not be parsed")
    end
  end
end
