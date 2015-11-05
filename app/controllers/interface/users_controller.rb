# encoding: utf-8
class Interface::UsersController < ActionController::Base
  # 1.选中一块注释的快捷键是",cb"
  # 2.下面这块是返回方法的演示。
  # 3.这是一个返回所有用户信息的接口
  # 4 一个假接口来 规范数据返回


  # 这是一个假接口 来对接口进行规范。:xx =>
  def example
    render :json => {
      :id => 1,
      :name => "zhangyu",
      :sex => "nan",
    }
  end



  # 这是一个假接口 来对接口进行规范 xx:
  def example2
    render json: {
      id: 2,
      name: "zhangyu",
      sex: "nan",
    }
  end



  # 重点！！！！！
  # 这是一个接口 来清晰我们几个概念例如
  # 比如 1.each  2.map  3.{}  4.do end
  #  do end 和 {} 是等价的 代码块 里面多用|| 滑竿
  #  each 和 map 是两个方法，each返回单个数据，map返回数组集合
  def example3
     1. map 方法使用
     names = User.all.map {|user| user[:name]}
     render :json => names

     2. map 方法使用
     names = User.all.map {|user| user.name}
     render :json => names

     3. map 方法使用
     names =User.all.map do |user|
       user[:name]
     end
     render :json => names

     4. 返回结果如下
     [
       "zhangyu",
       "kjn",
       "huangfeihong"
     ]
  end


  # 对数据库进行操作的接口,返回数据库中你想要的那些接口数据
  # 简单规范
  def all_users
    users = User.all.map { |user| {
        :id => user[:id],
        :name => user[:name],
        :sex => user[:sex]
    }
   }
  render :json => users
  end


  def all_users2
    users = User.all.map do |user| {
      :id => user.id,
      :name => user[:name],
      :sex => user[:sex]
    }
    end
    render :json => users
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
