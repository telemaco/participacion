class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_debate, :set_parent

  def create
    comment = Comment.build(@debate, current_user, params[:comment][:body])
    comment.save!
    comment.move_to_child_of(@parent) if reply?
    redirect_to @debate, notice: "Comentario guardado"
  end

  private
    def comment_params
      params.require(:comments).permit(:commentable_type, :commentable_id, :body)
    end

    def set_debate
      @debate = Debate.find(params[:debate_id])
    end

    def set_parent
      @parent = Comment.find_parent(params[:comment])
    end

    def reply?
      @parent.class == Comment
    end
end