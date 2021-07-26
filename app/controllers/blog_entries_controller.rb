class BlogEntriesController < ApplicationController
  before_action :set_blog_entry, only: [:show, :update, :destroy]

  # GET /blog_entries
  def index
    @blog_entries = BlogEntry.all

    render json: @blog_entries
  end

  # GET /blog_entries/1
  def show
    render json: @blog_entry
  end

  # POST /blog_entries
  def create
    @blog_entry = BlogEntry.new(blog_entry_params)

    @blog_entry.content = markdown(blog_entry_params[:content])

    if @blog_entry.save
      render json: @blog_entry, status: :created, location: @blog_entry
    else
      render json: @blog_entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /blog_entries/1
  def update
    @blog_entry.content = markdown(blog_entry_params[:content])

    if @blog_entry.update(blog_entry_params)
      render json: @blog_entry
    else
      render json: @blog_entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /blog_entries/1
  def destroy
    @blog_entry.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_entry
      @blog_entry = BlogEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_entry_params
      params.require(:blog_entry).permit(:title, :image_url, :content)
    end

    def markdown(text)
      md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, superscript: true, underline: true)

      md.render(text)
    end
end
