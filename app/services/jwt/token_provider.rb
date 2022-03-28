module Jwt::TokenProvider
  extend self

  # 暗号化のメソッド
  def call(payload)
    issue_token(payload)
  end

  private

  # issue_token」メソッドは、引数のpayload(今回でいうとuser_idのこと）をもとに暗号化しています。
  # 暗号化するにはrailsの秘密鍵が必要になるので第2引数で指定しています。
  def issue_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end
