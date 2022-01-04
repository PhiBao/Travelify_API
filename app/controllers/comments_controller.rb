class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :like, :report, :replies]
  before_action :admin_user, only: [:hide, :appear, :destroy]
  before_action :load_comment, only: [:like, :hide, :appear, :report, :create,
                                     :replies, :destroy]

  def create
    reply = @comment.replies.create!(body: params[:body], user_id: current_user&.id)

    render json: CommentBlueprint.render(reply, root: :reply), status: 200
  end

  def like
    act = @comment.actions.like.find_by(user_id: current_user.id)
 
    if act.present?
      act.destroy!
    else
      @comment.actions.like.create!(user_id: current_user.id)
    end
  end

  def report
    @comment.actions.report.create!(user_id: current_user.id, content: params[:content])
  end

  def hide
    @comment.hide!
  end

  def appear
    @comment.appear!
  end

  def destroy
    @comment.destroy!

    render json: {
      commentable_type: @comment.commentable_type,
      commentable_id: @comment.commentable_id,
      id: @comment.id
    }, status: 200
  end

  def replies
    page = params[:page] || 1
    if current_user&.admin?
      res = @comment.replies.newest.page(page)    
    else
      res = @comment.replies.appear.newest.page(page)
    end

    render json: {
      data: CommentBlueprint.render_as_hash(res, user: current_user),
      ids: res.pluck(:id),
      id: @comment.id
    }, status: 200
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Comment not found'] }, status: 404  
  end
end
