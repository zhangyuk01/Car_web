# encoding: utf-8
class Interface::UsersController < ActionController::Base
  # 1.选中一块注释的快捷键是",cb"
  # 2.下面这块是返回方法的演示。
  # 3.这是一个返回所有用户信息的接口
  def all_users
    render :json => {
      data: User.all
    }
  end
  # GET get the current user's friends
  #def get_friends
  #  user = User.find params[:id]
  #  friends = user.friends
  #  if friends.present?
  #    render :json => friends
  #  else
  #    render :plain => 'you are no friend'
  #  end
  #end

  ## POST set the current user's friends
  #def set_friends
  #  current_user = User.exists?(:id => params[:id])
  #  friend = User.exists?(:id => params[:friend_id])
  #  if params[:id] == params[:friend_id]
  #    render :plain => "you couldn't make friends with yourself "
  #  elsif current_user and friend
  #    current_user = User.find params[:id]
  #    friend = User.find params[:friend_id]
  #    relationship = Friend.new(:current_user_id => params[:id],:friend_id => params[:friend_id])
  #    relationship.save
  #    render :plain => 'relationship created !'
  #  else
  #    render :plain => 'the user is not registered'
  #  end
  #end

end
