class TagBlueprint < Blueprinter::Base
  identifier :id, name: :value
  field :name, name: :label
end