require 'monetize'
require 'rails_com'
module RailsTrade
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/payment",
      "#{config.root}/app/models/payment_method",
      "#{config.root}/app/models/promote",
      "#{config.root}/app/models/promote_charge",
      "#{config.root}/app/models/refund"
    ]

    config.generators do |g|
      g.rails = {
        helper: false
      }
      g.test_unit = {
        fixture: true,
        fixture_replacement: :factory_girl
      }
      g.templates.unshift File.expand_path('lib/templates', RailsCom::Engine.root)
    end

    initializer 'rails_trade.assets.precompile' do |app|
      app.config.assets.precompile += ['rails_trade_manifest.js']
    end
  end
end
