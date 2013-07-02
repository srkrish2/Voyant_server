Crowddesign::Application.routes.draw do
  authenticated :user do
    root :to => 'designs#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :designs do
    member do
      get :feedbacks
      post :request_feedback_for
    end
    resources :element_feedbacks do
      collection do
        post :batch_create
        get :survey
      end
    end

    resources :first_notice_feedbacks do
      collection do
        get :survey
      end
    end

    resources :impression_feedbacks do
      collection do
        post :batch_create
        get :vote
        get :survey
      end
    end

    resources :impression_vote_feedbacks do
      collection do
        get :survey
      end
    end

    resources :goal_feedbacks do
      collection do
        get :survey
      end
    end

    resources :guideline_feedbacks do
      collection do
        get :survey
      end

    end
  end

  resources :turkers do
    collection do
      post :find
    end
  end
end
