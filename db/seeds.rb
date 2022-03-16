require_relative "config"
require_relative "../lib/models"
require "ffaker"

def create_posts(count, &block)
  posts_data = count.times.map(&block)
  post_ids = Post.insert_all(posts_data, record_timestamps: true).map { |data| data["id"] }
  Post.where(id: post_ids)
end

def create_comments(posts, count, &block)
  comments_data = posts.flat_map { |post| count.times.map { block.(post) } }
  Comment.insert_all(comments_data, record_timestamps: true)
end

posts = create_posts(100) do
  { title: FFaker::CheesyLingo.title, body: FFaker::CheesyLingo.paragraph }
end

create_comments(posts, 1000) do |post|
  { post_id: post.id, body: FFaker::CheesyLingo.sentence, likes_count: rand(10) }
end
