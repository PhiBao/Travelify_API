# == Schema Information
#
# Table name: tours
#
#  id            :bigint           not null, primary key
#  kind          :integer
#  name          :string
#  description   :text
#  time          :string
#  limit         :integer
#  departure_day :datetime
#  terminal_day  :datetime
#  price         :decimal(9, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class TourBlueprint < Blueprinter::Base

  identifier :id
  fields :first_name, :last_name, :email, :kind, :name,
         :details, :price, :description
  field :images_data, name: :images

end
