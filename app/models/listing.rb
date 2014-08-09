class Listing < ActiveRecord::Base
  if Rails.env.development?
    has_attached_file :image, :styles => { :small => "200x", :medium => "360x", :thumb => "100x100>" }, :default_url => "default.jpg"
  else
    has_attached_file :image, :styles => { :small => "200x", :medium => "360x", :thumb => "100x100>" }, :default_url => "default.jpg",
                      :storage => :dropbox,
                      :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                      :path => ":style/:id_:filename"
  end

  validates_attachment :image, :presence => true,
                       :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] }
  # do_not_validate_attachment_file_type :image
  # validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/]

  validates :name, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  belongs_to :user
  has_many :orders

  scope :recent, ->{ order("created_at DESC") }
  scope :seller, ->(user){ where(user: user) }
  # scope :listing_by_user, ->(user_id){ whe}


end
