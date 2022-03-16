# Specific preloading with scoped associations example

This is an example of using scoped associations with Active Record, from Ruby
on Rails, to preload already filtered associations.

Like this...

```ruby
class Post < ActiveRecord::Base
  has_many :comments

  # Here you are defining an association, that will use Comment.popular,
  # to filter the Comment records.
  has_many :popular_comments, -> { popular }, class_name: "Comment"
end

class Comment < ActiveRecord::Base
  POPULAR = 9

  belongs_to :post

  # Here we are definining what `popular` means.
  scope :popular, -> { where(likes_count: POPULAR..) }
end

# Then you an preload directly just the popular comments
posts = Post.preload(:popular_comments).limit(5)
# => SELECT "posts".* FROM "posts" LIMIT $1  [["LIMIT", 5]]
# => SELECT "comments".* FROM "comments" WHERE "comments"."likes_count" >= $1 AND "comments"."post_id" IN ($1, $2, $3, $4, $5)

posts.each do |post|
  render_title(post)

  # You can call the association for each post without n+1 queries
  # because the association has already been preloaded
  post.popular_comments.each do |comment|
    render_comment(comment)
  end
end
```

In this way you can use your defined scopes, to build "scoped" associations to
help you preload just the records that your are going to need and save some
memory.

## How to run the examples

1. **Install the dependencies** with `bundle install`.

2. **Database setup** - run the command:

```
ruby db/setup.rb
```

3. **Run the examples** with `ruby examples/<file name>`. For example:

```
ruby example/00_without_scoped_association.rb
```

4. **Change the seeds**  on `db/seeds.rb` and re-run `ruby db/setup.rb` to test different scenarios.

*This example uses the [Active Record Playground](https://github.com/bhserna/active_record_playground) by [bhserna](https://bhserna.com)*

