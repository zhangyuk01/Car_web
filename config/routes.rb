Rails.application.routes.draw do
  #这个地方就是 创建controller就会有一个这样的引用文件
  resources :users

  #根路由
  root 'users#index'


  #接口的路由定义规则
  namespace :interface do
    resources :users, :only => [] do
      collection do
        #get :get_friends
        #get :set_friends
        get :example
        get :all_users
        get :all_users2
        get :find_user_by_id
        get :find_user_by_where
        post :register
      end
    end
  end

end
