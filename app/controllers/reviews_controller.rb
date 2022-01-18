class ReviewsController < ApplicationController
  before_action :logged_in_user, only: %i[like report comment]
  before_action :admin_user, only: %i[hide appear destroy]
  before_action :load_review, only: %i[like hide appear report comment comments destroy]

  def like
    act = @review.actions.like.find_by(user_id: current_user.id)
 
    if act.present?
      act.destroy!
    else
      @review.actions.like.create!(user_id: current_user.id)
    end
  end

  def report
    @review.actions.report.create!(user_id: current_user.id, content: params[:content])
  end

  def hide
    @review.hide!
  end

  def appear
    @review.appear!
  end

  def destroy
    @review.destroy!
    
    render json: { id: @review.id }
  end

  def comment
    comment = @review.comments.create!(body: params[:body], user_id: current_user&.id)

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
