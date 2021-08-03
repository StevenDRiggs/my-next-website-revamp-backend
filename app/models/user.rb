class User < ApplicationRecord
  has_secure_password

  def as_json(options={})
    options[:except] ||= [:password_digest, :created_at, :updated_at]

    super(options)
  end
end
