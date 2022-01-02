# == Schema Information
#
# Table name: tours
#
#  id            :bigint           snot null, primary key
#  kind          :integer
#  name          :string
#  description   :text
#  time          :string
#  limit         :integer
#  begin_date :datetime
#  return_date  :datetime
#  price         :decimal(9, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class TourBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :kind, :description, :departure,
         :details, :price, :rate
  field :images_data, name: :images
  field :vehicles_data, name: :vehicles

  view :normal do
    field :tags_data, name: :tags
  end

  view :created do
    association :tags, blueprint: TagBlueprint
  end
end
