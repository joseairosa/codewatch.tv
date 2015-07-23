Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << 'app/assets/stylesheets/tinymce/skins'
Rails.application.config.assets.paths << 'app/assets/javascripts/tinymce/skins'
Rails.application.config.assets.precompile += %w( jwplayer/jwplayer.flash.swf sky-forms-ie8.css respond.js placeholder-IE-fixes.js )
Rails.application.config.assets.precompile << 'emoji/**/*.png'
