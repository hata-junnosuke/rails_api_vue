module Jwt::UserAuthenticator
  # extend self」は、レシーバが「module　Jwt::UserAuthenticator」そのものであり、
  # module内で定義したメソッドが「Jwt::UserAuthenticator.メソッド名」として使えるようになるという意味
  extend self

  def call(request_headers)
    @request_headers = request_headers
    begin
      # TokenDecryptorファイルにあるcallメソッドを呼び出し、payloadに格納
      # 「payload,_」と書くことも多いですが、このアンダーバーにヘッダー情報が格納されます
      payload, _ = Jwt::TokenDecryptor.(token)
      return User.find(payload['user_id'])
    rescue
      return nil
    end
  end

  # ヘッダーのauthrizationのtokenのみを取得
  def token
    @request_headers['Authorization'].split(' ').last
  end
end
