class ReviewBlueprint < Blueprinter::Base
  identifier :id
  fields :body, :hearts, :likes, :created_at
  association :user, blueprint: UserBlueprint, view: :short
  field(:liked, if: ->(_field_name, _tour, options) { options[:user].present? }) do |review, options|
    review.actions.like.find_by(user_id: options[:user].id).present?
  end
  field :state, if: ->(_field_name, _tour, options) { options[:user]&.admin }
end
