class Project < ApplicationRecord
  # CONSTANTS
  CATEGORIES = [["", ""], "Heavy Lifting", "Food", "Automotive", "Sharing", "Advice", "Interpersonal Favours"]

  SYMBOLS = {
    category:     '<i class="fas fa-box-open"></i>',
    clock:      '<i class="far fa-clock"></i>',
    person:     '<i class="fas fa-people-carry"></i>',
    map:      '<i class="fas fa-map-marked-alt"></i>',

    empty:      '<span style="color: green">Empty</span>',
    has_vacancies:  '<span style="color: yellow">Filling Up</span>',
    almost_full:  '<span style="color: orange">Almost Full</span>',
    full:       '<span style="color: red">Full</span>',

    heavy_lifting:  '<i class="fas fa-weight-hanging"></i>',
    food:     '<i class="fas fa-drumstick-bite"></i>',
    automotive:   '<i class="fas fa-car"></i>',
    sharing:    '<i class="fas fa-praying-hands"></i>',
    advice:     '<i class="far fa-question-circle"></i>',
    interpersonal_favours: '<i class="fas fa-heart"></i>',
    scraped:    '<i class="fas fa-robot"></i>',
  }.map {|k, v| [k, v.html_safe]}.to_h

  # Enumerations
  enum status: [:empty, :has_vacancies, :almost_full, :full]

  # Associations
  belongs_to :user
  has_many :responses
  has_one :chatroom
  mount_uploaders :images, ImagesUploader
  #scopes
  scope :text_search, -> (text) {

    text_with_wildcard = "%#{text}%"
    where("title ILIKE ?", text_with_wildcard) if text_with_wildcard.present?
  }
  scope :number, -> (number) {
    where("max_people <= ?", number) if number.present?
  }
  scope :less_than, -> (less_than) {
    where("estimated_time <= ?", less_than) if less_than.present?
  }
  scope :greater_than, -> (greater_than) {
    where("estimated_time >= ?", greater_than) if greater_than.present?
  }
  scope :category, -> (category) {
    where("category = ?", category) if category.present?
  }




  # Validations
  validates :title, :estimated_time, :max_people, :detail, :location, :latitude, :longitude, :category, presence: true
  validates :max_people, numericality: { greater_than: -1 }
  validates :estimated_time, numericality: {greater_than: 0}
  validate :limits_volunteers_to_max_people

  # Functions
  def category_icon
    category_symbol = category.downcase.gsub(/ /, "_")
    return SYMBOLS[:"#{category_symbol}"]
  end

  def display_capacity
    return "#{max_people} #{SYMBOLS[:person]}".html_safe
  end

  def display_estimated_time
    return "#{estimated_time} #{SYMBOLS[:clock]}".html_safe
  end

  private
  def limits_volunteers_to_max_people
    if(max_people > 0 && responses.where(is_approved: true).size > max_people)
      errors.add(:max_people, "cannot be exceeded.")
    end
  end
end
