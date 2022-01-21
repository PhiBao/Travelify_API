class ReviewsController < ApplicationController
  before_action :logged_in_user, only: %i[like report comment]
  before_action :admin_user, only: %i[toggle destroy]
  before_action :load_review, only: %i[like toggle report comment comments destroy]

  def like
    act = @review.actions.like.find_by(user_id: current_user.id)
 
    if act.present?
      act.destroy!

      render json: { id: @review.id, liked: false }, status: 200
    else
      @review.actions.like.create!(user_id: current_user.id)

      if notification = Notification.liked.where(notifiable: @review)&.last
        count = Action.like.where(target: @review).uniq(&:user_id).size - 1;
        notification.update(user: current_user, others: count, status: "unread")
      else
        Notification.liked.create!(user_id: current_user.id,
                                   recipient_id: @review.user.id,
                                   notifiable: @review)
      end

      render json: { id: @review.id, liked: true }, status: 200
    end
  end

  def report
    @review.actions.report.create!(user_id: current_user.id, content: params[:content])
    if notification = Notification.reported.where(notifiable: @review)&.last
      count = Action.report.where(target: @review).uniq(&:user_id).size - 1;
      notification.update(user: current_user, others: count, status: "unread")
    else
      Notification.reported.create!(user_id: current_user.id,
                                    recipient_id: 1,
                                    notifiable: @review)
    end
  end

  def toggle
    if @review.hide?
      @review.appear!
    else
      @review.hide!
    end

    render json: { id: @review.id, state: @review.state }, status: 200
  end

  def destroy
    @review.destroy!
    
    render json: { id: @review.id }, status: 200
  end

  def comment
    comment = @review.comments.create!(body: params[:body], user_id: current_user&.id)
    if notification = Notification.commented.where(notifiable: @review)&.last
      count = Comment.appear.where(commentable: @review).uniq(&:user_id).size - 1;
      notification.update(user: current_user, others: count, status: "unread")
    else
      Notification.commented.create!(user_id: current_user.id,
                                     recipient_id: @review.user.id,
                                     notifiable: @review)
    end
    
    render json: { comment: CommentBlueprint.render_as_hash(comment),
                   parent_id: comment.commentable_id }, status: 201
  end

  def comments
    page = params[:page] || 1
    if current_user&.admin?
      res = @review.comments.newest.page(page)    
    else
      res = @review.comments.appear.newest.page(page)
    end

    render json: {
      id: @review.id,
      data: CommentBlueprint.render_as_hash(res, user: current_user),
      ids: res.pluck(:id)
    }, status: 200
  end

  private

  def load_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Review not found'] }, status: 404  
  end
end
