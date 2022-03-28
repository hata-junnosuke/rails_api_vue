class Api::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user&.authenticate(session_params[:password])
      token = Jwt::TokenProvider.call(user_id: user.id)
      # user情報とuserのserializerを引数にとり、その情報をもとにserializerインスタンスを作成しているのです。
      # 「.as_json」はserializerの形式を指定しています。
      # 「.deep_merge(user: { token: token })」はuserserializerにuserのもっているtoken情報を結合するよという意味です。
      # 「.merge」はコントローラ内でもよく使うと思うのですが、ハッシュの中にハッシュがあるような場合は「.deep_merge」を使う必要があります。
      render json: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer).as_json.deep_merge(user: { token: token })
    else
      render json: { error: { messages: ['メールアドレスまたはパスワードに誤りがあります。'] } }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end