class Post < CouchRest::Model::Base
  
  extend ActiveModel::Naming
  extend CouchConfig::DatabaseFromThread

  property :slug
  property :title
  property :body
  property :status
  property :user_id
  property :category

design do
	# view :slug
  view :category,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Post') && (doc['status'] == 'Active')) {
          emit(doc['category'], 1);
        }
      }"

  view :created_at, :descending => true,
    :map => 
      "function(doc) {
        if ((doc['couchrest-type'] == 'Post') && (doc['status'] == 'Active')) {
          emit(doc['created_at'], null);
        }
      }"
end

  timestamps!

  before_save :generate_slug_from_title

  def post_category(post)
     Category.by_name(:key => post.category).first 
  end

  def generate_slug_from_title
    if self.new_document?
      self.slug = Post.clean_title(title)
    end
  end

  def self.clean_title(the_slug)
    the_slug.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
  end
            
end
