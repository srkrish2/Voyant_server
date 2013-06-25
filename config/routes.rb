Crowddesign::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :designs do
    member do
      get :feedbacks
    end
    resources :element_feedbacks do
      collection do
        post :batch_create
      end
    end

    resources :first_notice_feedbacks do
    end
  end

  resources :turkers do
    collection do
      post :find
    end
  end
end
