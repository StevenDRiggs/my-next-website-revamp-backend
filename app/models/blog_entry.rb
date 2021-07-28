class BlogEntry < ApplicationRecord
  def self.find_by_slug(slug)
    BlogEntry.all.select{|blog_entry| blog_entry.slug == slug}[0] || nil
  end

  def slug
    self.title.parameterize.html_safe
  end

  def as_json(options=nil)
    super(options.merge(methods: :slug))
  end
end
