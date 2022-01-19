class UserBlueprint < Blueprinter::Base
  identifier :id
  field :avatar_url

  view :full do
    fields :first_name, :last_name, :email, :phone_number,
         :address, :birthday, :activated, :admin, :created_at
  end

  view :short do
    field :username
  end

  view :admin do
    include_view :full
    field :username
    exclude :admin
  end
  
end
