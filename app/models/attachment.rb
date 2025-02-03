class Attachment < ApplicationRecord
    belongs_to :attachable, :polymorphic => true

    validates_presence_of :file, message: "El archivo adjunto no puede estar vacio."

    before_destroy :delete_s3_image
    enum state: [:warning, :success, :danger]

    STATES = [
      [:warning, "Pendiente"],
      [:success, "Aprobado"],
      [:danger, "Rechazado"]
    ]

    def delete_s3_image
      key = file.split('amazonaws.com/')[1]
      S3_BUCKET.object(key).delete unless key.nil?
    end

    def display_file
      if [".pdf", ".doc", "docx", ".xls", "xlsx"].include?(file.last(4))
        "/images/attachment.png"
      else
        file
      end
    end
  end
