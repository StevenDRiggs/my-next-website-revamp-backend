# Preview all emails at http://localhost:3000/rails/mailers/contact
class ContactPreview < ActionMailer::Preview
  def auto_reply
    ContactMailer.with(
      contact: {
        name: 'Test Contact',
        email: 'test@email.com',
        message: 'This is a test message. How does it look?',
    }).auto_reply
  end

  def contact_me
    ContactMailer.with(
      contact: {
        name: 'Test Contact',
        email: 'test@email.com',
        message: 'This is a test message. How does it look?',
    }).contact_me
  end
end
