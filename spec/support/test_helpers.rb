module TestHelpers
  def oauth2_mock(provider, name: nil, email: nil)
    name = Faker::Movies::Ghostbusters.character if name.blank?
    email = Faker::Internet.email if email.blank?
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(provider,
      uid: "12345",
      info: {name: name, email: email},
      credentials: {token: "1a2b3c", secret: "4d5e6f"})
  end
end
