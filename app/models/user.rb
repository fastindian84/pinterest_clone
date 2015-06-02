class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_commontator
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :pins

  has_attached_file :avatar, :styles => { :medium => "300x300>", :comment => "48x48#", :navbar => "32x32#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  attr_accessor :remove_avatar

  before_save :delete_avatar, if: ->{ remove_avatar == '1' && !avatar_updated_at_changed? }

  private

  def delete_avatar
    self.avatar = nil
  end
end
