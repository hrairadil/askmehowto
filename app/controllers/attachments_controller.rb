class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  before_action :set_entity

  def destroy
    @attachment.destroy! if @attachable.user == current_user
  end

  private
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end
    def set_entity
      @attachable = @attachment.attachable_type.constantize.find(@attachment.attachable_id)
    end
end
