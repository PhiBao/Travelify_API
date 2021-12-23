# == Schema Information
#
# Table name: tour_tags
#
#  id      :integer          not null, primary key
#  tag_id  :integer
#  tour_id :integer
#
# Indexes
#
#  index_tour_tags_on_tour_id_and_tag_id  (tour_id,tag_id) UNIQUE
#

class TourTag < ApplicationRecord
  belongs_to :tag
  belongs_to :tour

  validates :tag_id, presence: true
  validates :tour, uniqueness: { allow_blank: false,
                                 scope: :tag, 
                                 messages: "should have a defined tag" }

  def tag_attributes=(hash)
    self.tag = Tag.find_or_create_by(hash)
  end                
end
