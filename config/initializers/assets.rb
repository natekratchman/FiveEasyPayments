# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w(1.jpg 2.jpg 3.jpg 4.jpg 5.jpg 6.jpg 7.jpg 8.jpg author.png bg-about.jpg bg-service.jpg bg-static.jpg home-slide-1.jpg logo-top.png ben-gross.jpg kana-abe.jpg nate-kratchman.jpg port-item-1.jpg scrooge-mcduck.jpg scrooge-mcduck2.png)
Rails.application.config.assets.precompile += %w( vendor/assets/images/*.jpg vendor/assets/images/*.png )
