!SLIDE
# SchemaPlus #
### enhanced capabilities for schema definition and querying ###
### Ronen Barzel & Michał Łomnicki ###

!SLIDE bullets smaller
# History #
* Simon Harris / harukizaemon
* redhillonrails_core (2006, 2009)
* foreign_key_migrations => automatic_foreign_key
* schema_plus (2011)

!SLIDE bullets
# Goals #
* solid base
* well-tested
* well-documented
* better name :)

!SLIDE smaller
## Plain ActiveRecord ##

    @@@ruby
    create_table :comments do |t|
        t.text :body
        t.integer :post_id
        t.integer :author_id
    end
    execute "ALTER TABLE comments ADD FOREIGN KEY (post_id) \
        REFERENCES (posts)"
    execute "ALTER TABLE comments ADD FOREIGN KEY (author_id) \ 
        REFERENCES (users)"
    add_index :comments, :post_id

!SLIDE smaller
## With schema_plus ##

    @@@ruby
    create_table :comments do |t|
        t.text :body
        t.integer :post_id, :index => true
        t.integer :author_id, :references => :users
    end

!SLIDE
## auto-index foreign keys ##

    @@@ruby
    # without auto_index
    t.integer :post_id, :index => true

    # with auto_index
    t.integer :post_id

!SLIDE smaller
## index ##

    @@@ruby
    t.string :area_code
    t.string :local_number, 
         :index => { :unique => true, :with => :area_code }

!SLIDE bullets
# Other features #
* global, per table and per statement config
* expressional indexes
* views

!SLIDE smaller
# SchemaAssociations #

    @@@ruby
    # without schema_associations
    class Post < ActiveRecord::Base
        belongs_to :author
        has_many :comments
    end

!SLIDE smaller
# SchemaAssociations #

    @@@ruby
    # without schema_associations
    class Post < ActiveRecord::Base
        # associations auto-created from foreign keys
    end

!SLIDE smaller
# SchemaValidations #

    @@@ruby
    create_table :posts do |t|
        t.integer :author_id, :null => false, :references => :users
        t.integer :likes_count
        t.string :content, :limit => 5_000
    end

!SLIDE smaller
# SchemaValidations #

    @@@ruby
    # without schema_validations
    class Post < ActiveRecord::Base
        validates :author, :presence => true
        validates :likes_count, :numericality => true
        validates :content, :length => { :maximum => 5_000 }
    end

!SLIDE smaller
# SchemaValidations #

    @@@ruby
    # with schema_validations
    class Post < ActiveRecord::Base
    end

!SLIDE bullets smaller
# Schema Family #

* Scary?
* ...but that's next step for active record pattern

!SLIDE
# Questions #

## http://github.com/lomba ##
