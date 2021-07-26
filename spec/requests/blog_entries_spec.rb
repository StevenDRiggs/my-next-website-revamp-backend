require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/blog_entries", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # BlogEntry. As you add validations to BlogEntry, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      title: 'test title',
      image_url: 'an.image.url',
      content: "After TWO WEEKS of R10 errors, I finally have my site up with my blog! Special thanks to Derik Linch for the answer!\n\nIt turns out, deploying a Next.js app to Heroku requires one simple modification, not covered ANYWHERE on Google.\n\nIn your `package.json` file, NOT in a `Procfile` as the official website discusses, replace this line:\n`\"start\": \"next start\"`\nwith this one:\n`\"start\": \"next start -p $PORT\"`\n\nTHAT'S IT! I am not sure why Heroku needs that slight modification (instead of it being built in), but I am ecstatic that it works!\n\nThat's all this week. Happy coding!",
    }
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # BlogEntriesController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      BlogEntry.create! valid_attributes
      get blog_entries_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      blog_entry = BlogEntry.create! valid_attributes
      get blog_entry_url(blog_entry), as: :json
      expect(response).to be_successful
    end
  end

  fdescribe "POST /create" do
    context "with valid parameters" do
      it "creates a new BlogEntry" do
        expect {
          post blog_entries_url,
               params: { blog_entry: valid_attributes }, headers: valid_headers, as: :json
        }.to change(BlogEntry, :count).by(1)
      end

      it "renders a JSON response with the new blog_entry" do
        post blog_entries_url,
             params: { blog_entry: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new BlogEntry" do
        expect {
          post blog_entries_url,
               params: { blog_entry: invalid_attributes }, as: :json
        }.to change(BlogEntry, :count).by(0)
      end

      it "renders a JSON response with errors for the new blog_entry" do
        post blog_entries_url,
             params: { blog_entry: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested blog_entry" do
        blog_entry = BlogEntry.create! valid_attributes
        patch blog_entry_url(blog_entry),
              params: { blog_entry: new_attributes }, headers: valid_headers, as: :json
        blog_entry.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the blog_entry" do
        blog_entry = BlogEntry.create! valid_attributes
        patch blog_entry_url(blog_entry),
              params: { blog_entry: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the blog_entry" do
        blog_entry = BlogEntry.create! valid_attributes
        patch blog_entry_url(blog_entry),
              params: { blog_entry: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested blog_entry" do
      blog_entry = BlogEntry.create! valid_attributes
      expect {
        delete blog_entry_url(blog_entry), headers: valid_headers, as: :json
      }.to change(BlogEntry, :count).by(-1)
    end
  end
end
