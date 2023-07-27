class OauthCredential < ApplicationRecord
  belongs_to :user

  store_attribute :data, :secret, :string
end
