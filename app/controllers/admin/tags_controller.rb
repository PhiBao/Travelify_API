module Admin
  class TagsController < ApplicationController
    before_action :load_tag, only: %i[update destroy] 

    def index
      render json: { data: { list: TagBlueprint.render_as_hash(Tag.all, view: :home),
                             type: "tags" } }, status: 200
    end

    def create
      @tag = Tag.create(tag_params)
      if @tag.save
        render json: TagBlueprint.render(@tag, view: :home, root: :tag), status: 200
      else
        render json: { messages: ["A error has occurred"] }, status: 400
      end
    end

    def update
     if @tag.update(update_params)
        render json: TagBlueprint.render(@tag, view: :home, root: :tag), status: 200
      else
        render json: { messages: @tag.errors.full_messages }, status: 400
      end
    end

    def destroy
      if @tag.destroy
        render json: { id: @tag.id }
      else
        render json: { messages: @tag.errors.full_messages }, status: 400
      end
    end

    private

    def load_tag
      @tag = Tag.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { messages: ['Tag not found'] }, status: 404  
    end

    def tag_params
      params.permit(:illustration, :name)
    end
  end
end
