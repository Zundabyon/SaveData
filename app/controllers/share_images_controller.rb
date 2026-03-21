class ShareImagesController < ApplicationController
  def create
    # Base64データを受け取る
    image_data = params[:image].sub(/^data:image\/\w+;base64,/, '')
    decoded_image = Base64.decode64(image_data)

    # 一時ファイルとして保存
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(decoded_image),
      filename: "share_#{SecureRandom.hex(8)}.png",
      content_type: "image/png"
    )

    render json: { url: url_for(blob) }
  end
end