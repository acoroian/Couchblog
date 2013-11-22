class User < CouchRest::Model::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me

  # extend DeviseOverrides::SessionSerializer
  # extend ActiveModel::Naming
  # extend CouchConfig::DatabaseFromThread
  use_database COUCH_DB

  property :username
  property :slug
  property :email
  property :time_zone, :default => "Pacific Time (US & Canada)"
  property :password
  property :password_confirmation
  property :remember_me

 design do
#   # view :slug
#   # view :member_name
    view :email,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'User') && (doc['status'] == 'Active')) {
          emit(doc['email'], null);
        }
      }"
#   # view :_id

#   # view :created_at, :descending => true
 end
  timestamps!

  before_save :downcase_email
  before_save :generate_slug_from_username

  def generate_slug_from_username
    if self.new_document?
      self.slug = User.clean_username(username)
    end
  end

  def self.clean_username(the_slug)
    the_slug.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
  end
  
  def downcase_email
    self.email = email.downcase
  end

  #Devise Override For Finding User When Logging In
  def self.find_for_authentication(conditions)
    User.by_email(:key => conditions['email']).first 
  end
                 
end


