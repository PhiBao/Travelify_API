class TagBlueprint < Blueprinter::Base
  view :normal do
    fields :id, :name
  end
  view :option do
    field :id, name: :value
    field :name, name: :label
  end
  view :home do
    include_view :normal
    field :illustration_url
    field :tour_tags_count, name: :tours_count
  end
end
