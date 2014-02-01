class SimonAsks::Question < ActiveRecord::Base
  has_many :answers, class_name: 'QuestionAnswer'
  has_many :comments, as: 'owner'

  belongs_to :user, class_name: SimonAsks.user_class

  attr_accessible :title, :content

  validates_presence_of :title, :content

  # incements views_counter by one
  def increment_views!
    increment!('views_count')
  end

  # Mark question as a question of the day
  def mark!
    update_attribute(:marked, true)
  end

  # Unmark question as a question of the day
  def unmark!
    update_attribute(:marked, false)
  end

  class << self
    def cache_count
      Rails.cache.fetch('simon_asks_questions_count', expires_in: 30.minutes) {
        count
      }
    end

    def cached_latest
      Rails.cache.fetch('latest_questions', expires_in: 10.minutes) {
        where(marked: false).limit(6)
      }
    end

    def cached_most_read
      Rails.cache.fetch('most_read_questions', expires_in: 10.minutes) {
        unscoped.order('views_count DESC').limit(3).all
      }
    end    
  end
end
