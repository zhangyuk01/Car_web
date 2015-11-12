#这个接口就是简单的一个ruby语言教学，适合新手学习
# encoding: utf-8
class Interface::UsersController < ActionController::Base
  ####[1]-----------技巧篇
  # 1.选中一块注释的快捷键是 ",cb"
  # 2.取消注释的快捷键是 "选中:s/#//" 依次操作




  ####[2]----------Ruby 语言基础篇
  # 1.  .nil? .empty? .blank? .present? 区别
  # 2.  .nil? 如果不是对象那么他就是nil的，返回true，(这句话是通过建模来加强理解，下面都是）===>
  #           例子：nil.nil? => true  false.nil => false
  #
  # 3.  .empty? 前提对象是存在，否则用不来.empty , 如果对象是空那么他就是empty的，返回true ====>
  #           例子："lala".empty? => false "".empty? => true " ".empty? => 有空格就返回false
  #
  # 4.  .blank? 同时满足.nil? 和 .empty? 如果是空的，那么就是blank的
  #
  # 5.  .present? .blank的反义词，如果对象中不是空的，就是present的


  ####[3]----------Ruby On Rails 接口篇
  # 这是一个假接口 来对接口进行规范。:xx =>
  def example
    render :json => {
      :id => 1,
      :name => "zhangyu",
      :sex => "nan",
      :lover => "woman",
      :aihao => "play"
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

  #总结:
  #  1.    XX:  等价于 :XX =>
  #  2.    {}   等价于 do end
  #  3.    each 返回每一个对象
  #  4.    map  返回数组，内部是hash
  #                 例子: =====>看右面的图形    [{name:'zhangyu'},{},{},{}]
  #  5.    [:XX]  是Ruby中的hash 根据key 来选择value
  #                 例子: =====>user[:name]  params[:id]
  #  6.    正是因为 有4个等价，所以在写接口的时候会有很多种写法，一定要掌握原理




  # 条件查找 总结
  # 1. find 条件查找
  def find_user_by_id
     user = User.find params[:id]
     render :json => user
  end

  # 2. where 条件查找
  def find_user_by_where
     user = User.where("name = ?",params[:name]);
     render :json => user
  end


 # 3.登陆实现机制，通过用户名登陆
  def login
    user = User.find_by_phone(params[:phone])
  end


  #4. 注册实现机制,通过手机号注册
  def register
     user =  User.find_by_phone(params[:phone])
     if user.present?
       render :json => {
         :success => false, :message => "该号码已经被注册"
       }
     elsif
       user = User.new(:phone => params[:phone], :user_password => params[:user_password])
       user.save!
       render :json => {:success => true, :message => "成功注册", :user => user}
     else
       render :json => {:success => false, :message => "注册失败"}
     end
  end


  # 以下是用户注册和登陆的接口
  def sign_up
    user = User.find_by_phone(params[:phone])
    vcode = ValidationCode.find_by_phone(params[:phone])
    if user.present?
      render :json => {:success => false, :message => "该号码已注册"}
    elsif params[:validate_code] == vcode.code
      user = User.new(:phone => params[:phone], :password => params[:passwd])
      user.email = "#{user.phone}@fake.email"
      user.name = "匿名"
      user.token = generate_token
      user.save!
      render :json => {:success => true, :message => "成功注册", :user => user }
    else
      render :json => {:success => false, :message => "验证码不正确"}
    end
  end


  def get_back_password
    user = User.find_by_phone(params[:phone])
    #vcode = (Rails.application.config.validate_code[params[:phone]] == params[:validate_code])
    vcode = ValidationCode.find_by_phone(params[:phone])
    #if user && vcode
    if vcode.code == params[:validate_code]
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  def sign_in
    user = User.find_by_phone(params[:phone])
    if user
      if user.valid_password?(params[:passwd])
        user.token = generate_token if user.token.blank? # user.token 和 user.update :token => user.token是不是重复了？
        user.update(:token => user.token)
        if user.head_pic
          user_head_pic = "/uploads/head_pic/#{user.phone}/" + "#{user.head_pic}"
        else
          user_head_pic = nil
        end
        render json: {:success => true, :result => {:id => user.id, :user_phone => user.phone, :token => user.token, :user_name => user.name, :user_address => user.address, :user_head_pic => SERVER + user_head_pic}}
      else
        render json: {:success => false,  :message => '密码错误'}
      end
    else
      render :json => {:success => false, :message => "您还没有注册"}
    end
  end

  def change_head_pic # 更换头像
    user = User.find_by_token(params[:token])
    img_name = params[:file].original_filename
    public_root_dir = "/opt/app/yuehouse/current/public"
    img_dir = "/uploads/head_pic/#{user.phone}/"
    public_dir = public_root_dir + img_dir
    # 确保这个文件夹存在
    `mkdir -p #{public_dir}`
    img_save_path = File.join(public_dir,img_name)
    File.open(img_save_path,"wb") {|f| f.write(params[:file].read)}
    user.update(:head_pic => img_name) # 将图片的名字存在数据库里面
    render :json => {:success => true, :image_dir => SERVER + img_dir + img_name}
  end

  def change_password
    user = User.find_by_token(params[:token])
    if user && user.valid_password?(params[:old_password])
      user.password = params[:user_password]
      user.save
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  def reset_password
    user = User.find_by_phone(params[:phone])
    if user
      user.password = params[:password]
      user.save
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end


  def validate_code # 生成验证码
    phone = params[:phone]
    code = params[:validate_code]
    check = ValidationCode.find_by_phone phone
    if check.present?
      check.update(:code => code)
      render :json => check
    else
      validation_code = ValidationCode.new(phone:phone, code:code)
      if validation_code.save
        render :json => validation_code
      else
        render :json => "生成验证码失败"
      end
    end
  end

  def change_name
    user = User.find_by_token(params[:token])
    user.name = params[:name]
    user.save
    render :json => {:success => true, :name => user.name}
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
