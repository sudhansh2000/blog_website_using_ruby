require 'rails_helper'

RSpec.describe "V1::PostsController", type: :request do
  let!(:category) { create(:category) }
  let!(:user2) { create(:user) }
  let!(:post1) { create(:post, user: user2, category: category) }

  describe "create" do
    it "show all post" do
        get "/v1/posts"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to be >= 1
        expect(json[0]["id"]).to eq(post1.id)
    end

    it "show all the posts of category" do
        get "/v1/categories/#{category.id}/posts"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to be >= 1
        expect(json[0]["title"]).to eq(post1.title)
    end

    it "show all the posts of perticular user" do
        get "/v1/users/#{user2.id}/posts"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json.length).to be >= 1
        # puts json
        expect(json[0]["title"]).to eq(post1.title)
    end
  end

  describe "show" do
    it "show post method" do
        get "/v1/posts/#{post1.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json).to be_a(Hash)
        expect(json["id"]).to eq(post1.id)
      expect(json["title"]).to eq(post1.title)
    end
  end

  describe "create" do
    it "create post" do
      params = {
        post: {
          user_id: user2.id,
          category_id: category.id,
          title: "new post",
          content: "new post content",
          is_private: false,
          tags: [ "tag1", "tag2" ]
        }
      }
      post "/v1/users/#{user2.id}/posts", params: params
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["post"]["title"]).to eq("new post")
    end
  end

  describe "update" do
    it "update post" do
      params = {
        post: {
          post_id: post1.id,
          title: "updated post"
        }
      }
      patch "/v1/posts/#{post1.id}", params: params
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Post updated successfully")
    end
  end

  describe "delete" do
    it "delete post" do
      delete "/v1/posts/#{post1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Post deleted successfully")
    end
  end
end
