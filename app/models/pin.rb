class Pin < ActiveRecord::Base
  acts_as_votable
  acts_as_commontable

  belongs_to :user
  has_many :images, as: :attachable_image, dependent: :destroy, class_name: "Picture"

  def preview
    images.first.image.url
  end
end
