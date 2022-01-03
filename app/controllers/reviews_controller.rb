class ReviewsController < ApplicationController
  before_action :load_review, only: [:like]

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

  private

  def load_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { messages: ['Review not found'] }, status: 404  
  end
end
