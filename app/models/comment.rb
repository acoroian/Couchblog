class Comment < CouchRest::Model::Base
  
  extend ActiveModel::Naming
  extend CouchConfig::DatabaseFromThread

  property :body
  property :status
  property :name
  property :email
  property :website
  property :post_id
  property :temp_post_id
  
  design do
    view :temp_post_id
    view :_id
  end

  timestamps!

  def generate_post_id
    "test"
  end
          
end
