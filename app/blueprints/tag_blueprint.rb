class TagBlueprint < Blueprinter::Base
  identifier :id, name: :value
  field :name, name: :label

  view :home do
    field :illustration_url
    field :tour_tags_count, name: :tours_count
  end
end