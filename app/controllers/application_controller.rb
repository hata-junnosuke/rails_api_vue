# application controllerではエラーに関する処理を記載しています
class ApplicationController < ActionController::Base
  # 「protect_from_forgery with:」メソッドは自動でCSRF対策の設定
  protect_from_forgery with: :null_session
  class AuthenticationError < StandardError; end

  rescue_from ActiveRecord::RecordInvalid, with: :render_422
  rescue_from AuthenticationError, with: :not_authenticated

  # 現在ログイン中のuserでなければエラーを発生させる
  def authenticate
    raise AuthenticationError unless current_user
  end

  # 「current_user」は現在ログイン中のuserかどうかを判定するメソッドです。
  # Jwt::UserAuthenticator(サービスファイル)で定義したcallメソッドを呼びます。
  # 引数にはリクエストのヘッダー情報を送ります。
  # またuser情報が取得できた場合は@current_userに代入され、できない場合はfalseを返します。
  def current_user
    @current_user ||= Jwt::UserAuthenticator.(request.headers)
  end

  private

  # json形式でエラーメッセージとstatusを返すメソッド
  def render_422(exception)
    render json: { error: { messages: exception.record.errors.full_messages } }, status: :unprocessable_entity
  end

  # json形式でエラーメッセージとstatusを返すメソッド
  def not_authenticated
    render json: { error: { messages: ['ログインしてください'] } }, status: :unauthorized
  end
end
