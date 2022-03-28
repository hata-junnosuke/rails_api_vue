class UserSerializer < ActiveModel::Serializer
  # これでjson形式でid,name,emailを返すようになる
  attributes :id, :name, :email
end