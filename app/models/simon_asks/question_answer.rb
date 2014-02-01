class SimonAsks::QuestionAnswer < ActiveRecord::Base
  # Relations
  belongs_to :user, class_name: SimonAsks.user_class
  belongs_to :question, counter_cache: :answers_count
  has_many :comments, as: 'owner'

  # Accesses
  attr_accessible :content, :user, :question, :accepted

  # Validation
  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :question

  scope :accepted_only, where(accepted: true)

  # Methods
  def can_edit?(user)
    self.user == user
  end
end
