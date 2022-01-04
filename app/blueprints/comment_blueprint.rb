class CommentBlueprint < Blueprinter::Base
  identifier :id
  fields :body, :likes, :created_at
  association :user, blueprint: UserBlueprint, view: :short
  field(:liked, if: ->(_field_name, _tour, options) { options[:user].present? }) do |comment, options|
    comment.actions.like.find_by(user_id: options[:user].id).present?
  end
  field :size do |comment, options|
    if options[:user]&.admin?
      comment.replies.size
    else
      comment.replies.appear.size
    end
  end
  field(:reply_to, if: ->(_field_name, comment, _options) { comment.commentable_type == 'Comment' }) do |comment|
    comment.commentable.user.username
  end
  field :state, if: ->(_field_name, _tour, options) { options[:user]&.admin? }
end
