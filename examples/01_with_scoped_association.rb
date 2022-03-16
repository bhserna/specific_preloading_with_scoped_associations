require_relative "config"
require_relative "../lib/models"

def render_title(post)
  puts
  puts post.title
  puts "-" * post.title.size
end

def render_comment(comment)
  puts "* #{comment.body}"
end

# Show popular comments for each post

# Preload directly just the popular comments
posts = Post.preload(:popular_comments).limit(5)
# Post Load (0.2ms)  SELECT "posts".* FROM "posts" LIMIT $1  [["LIMIT", 5]]
# Comment Load (0.3ms)  SELECT "comments".* FROM "comments" WHERE "comments"."likes_count" >= $1 AND "comments"."post_id" IN ($1, $2, $3, $4, $5)

posts.each do |post|
  render_title(post)

  # You can call the association for each post without n+1 queries
  post.popular_comments.each do |comment|
    render_comment(comment)
  end
end
