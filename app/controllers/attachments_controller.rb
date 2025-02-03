class AttachmentsController < ApplicationController
  expose :attachment

  def update
    attachment.update(attachment_params)
    redirect_back(fallback_location: root_path)
  end

  private
    def attachment_params
      params.require(:attachment).permit(:state)
    end
end
