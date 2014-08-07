class Listing < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "default.jpg",
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml")

  validates_attachment :image, :presence => true,
                       :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] }
  # do_not_validate_attachment_file_type :image
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]
end
