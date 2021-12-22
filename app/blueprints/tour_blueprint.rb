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
  fields :first_name, :last_name, :email, :kind, :name,
         :details, :price, :description, :departure
  field :images_data, name: :images
end
