class Picture < ActiveRecord::Base
  belongs_to :attachable_image, polymorphic: true
  has_attached_file :image, :styles => { :medium => "300x300>" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  default_scope -> { order('created_at ASC') }
  def preview
    image.url
  end
end
