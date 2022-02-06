class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i[reply like report]
  before_action :admin_user, only: :toggle
  before_action :load_comment, only: %i[like toggle report reply replies update destroy]
  before_action :owner_comment, only: %i[update destroy]

  def update
    @comment.update(body: params[:body])

    render json: { id: @comment.id,
                   body: @comment.body }, status: 200
  end

  def reply
    reply = @comment.replies.create!(body: params[:body], user_id: current_user&.id)
    if notification = Notification.replied.where(notifiable: @comment)&.last
      count = Comment.appear.where(commentable: @comment).uniq(&:user_id).size - 1;
      notification.update(user: current_user, others: count, status: "unread")
    else
      Notification.replied.create!(user_id: current_user.id,
                                   recipient_id: @comment.user_id,
                                   notifiable: @comment)
    end

    render json: { reply: CommentBlueprint.render_as_hash(reply),
                   parent_id: reply.commentable_id }, status: 201
  end

  def like
    act = @comment.actions.like.find_by(user_id: current_user.id)
 
    if act.present?
      act.destroy!

      render json: { id: @comment.id, liked: false }, status: 200
    else
      @comment.actions.like.create!(user_id: current_user.id)
      if notification = Notification.liked.where(notifiable: @comment)&.last
        count = Action.like.where(target: @comment).uniq(&:user_id).size - 1;
        notification.update(user: current_user, others: count, status: "unread")
      else
        Notification.liked.create!(user_id: current_user.id,
                             recipient_id: @comment.user_id,
                             notifiable: @comment)
      end

      render json: { id: @comment.id, liked: true }, status: 200
    end
  end

  def report
    @comment.actions.report.create!(user_id: current_user.id, content: params[:content])
    if notification = Notification.reported.where(notifiable: @comment)&.last
      count = Action.report.where(target: @comment).uniq(&:user_id).size - 1;
      notification.update(user: current_user, others: count, status: "unread")
    else
      Notification.reported.create!(user_id: current_user.id,
                                    recipient_id: 1,
                                    notifiable: @comment)
    end
  end

  def toggle
    if @comment.hide?
      @comment.appear!
    else
      @comment.hide!
    end

    render json: { id: @comment.id,
                   state: @comment.state }, status: 200
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

  def owner_comment
    unless current_user&.admin? || current_user == @comment.user
      render json: { messages: ['You don\'t have permission to access this'] }, status: 403
    end
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['User not found'] }, status: 404
  end
end
