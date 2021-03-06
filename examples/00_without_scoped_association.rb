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

# Preload all comments for each post
posts = Post.preload(:comments).limit(5)
# Post Load (0.5ms)  SELECT "posts".* FROM "posts" LIMIT $1
# Comment Load (0.6ms)  SELECT "comments".* FROM "comments" WHERE "comments"."post_id" IN ($1, $2, $3, $4, $5)

posts.each do |post|
  render_title(post)

  # Select just the popular comments
  post.comments.select(&:popular?).each do |comment|
    render_comment(comment)
  end
end
