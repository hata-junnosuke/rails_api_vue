module Jwt::TokenDecryptor # decryptは復号化
  extend self

  # 復号化メソッド
  def call(token)
    decrypt(token)
  end

  private

  # プライペートメソッドのdecryptは、引数のtokenをもとに復号化しています。
  # 復号にはrailsのrailsの秘密鍵が必要になるので第2引数で指定しています。
  def decrypt(token)
    begin
      JWT.decode(token, Rails.application.credentials.secret_key_base)
    rescue
      raise InvalidTokenError
    end
  end
end
class InvalidTokenError < StandardError; end;