class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:report]
  before_action :admin_user, only: [:hide, :appear, :delete]
  before_action :load_review, only: [:like, :hide, :appear, :report, :destroy]

  def create
  end

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
    
    render json: {id: @review.id}
  end

  private

  def load_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Review not found'] }, status: 404  
  end
end
