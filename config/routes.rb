Rails.application.routes.draw do

  scope module: 'trade' do
    resources :payments, only: [:index] do
      get :result, on: :collection
      get :wxpay_result, on: :collection
      match :notify, on: :collection, via: [:get, :post]
      match :alipay_notify, on: :collection, via: [:get, :post]
      match :wxpay_notify, on: :collection, via: [:get, :post]
      match :wxpay_faker, on: :collection, via: [:get, :post]
    end
    resources :buyers, only: [] do
      get :search, on: :collection
    end
  end

  scope :admin, module: 'trade/admin', as: 'admin' do
    get 'trade' => 'trade#index'

    resources :buyers do
      get :overdue, on: :collection
      get :orders, on: :member
      put :remind, on: :collection
    end
    resources :carts, except: [:new] do
      get :total, on: :collection
      get :doc, on: :collection
      get :only, on: :collection
      resources :cart_serves do
        get :single, on: :collection
        get :total, on: :collection
        post :add, on: :collection
      end
    end
    resources :orders do
      get :payments, on: :collection
      get :refresh, on: :collection
      patch :refund, on: :member
      resources :order_payments
    end
    resources :order_items
    resources :payments do
      resources :payment_orders do
        patch :cancel, on: :member
      end
      get :dashboard, on: :collection
      patch :analyze, on: :member
      patch :adjust, on: :member
    end
    resources :payment_strategies
    resources :payment_methods do
      resources :payment_references, as: :references
      get :unverified, on: :collection
      get :mine, on: :collection
      patch :verify, on: :member
      patch :merge_from, on: :member
    end
    resources :produces
    resources :promotes do
      get :search, on: :collection
      resources :promote_charges, as: 'charges'
    end
    resources :promote_buyers
    resources :promote_goods do
      get :goods, on: :collection
    end
    resources :refunds do
      patch :confirm, on: :member
      patch :deny, on: :member
    end
    resources :serves do
      get :search, on: :collection
      resources :serve_charges, as: 'charges'
    end
  end

  scope :my, module: 'trade/my', as: 'my' do
    resources :buyers
    resources :carts do
      get :total, on: :member
      resources :cart_items
    end
    resources :good_providers
    resources :orders do
      post :direct, on: :collection
      get :refresh, on: :collection
      get :paypal_pay, on: :member
      get :alipay_pay, on: :member
      get :wxpay_pay, on: :member
      patch :stripe_pay, on: :member
      get :paypal_execute, on: :member
      get :pay, on: :member
      get 'payment_type' => :edit_payment_type, on: :member
      put 'payment_type' => :update_payment_type, on: :member
      patch 'payment_type' => :update_payment_type, on: :member
      get 'cancel' => :edit_cancel, on: :member
      put 'cancel' => :update_cancel, on: :member
      put :refund, on: :member
      get :check, on: :member
    end
    resources :order_items
    resources :payment_methods
  end

end
