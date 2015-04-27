class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to channel, comment: render(template: 'comments/submit')
    else
      render_errors
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def channel
      "/questions/#{ @commentable.try(:question).try(:id) || @commentable.id }/comments"
    end

    def set_commentable
      commentable = params[:commentable].classify.constantize
      id = (params[:commentable].singularize + '_id').to_sym
      @commentable = commentable.find(params[id])
    end

    def render_errors
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
end
