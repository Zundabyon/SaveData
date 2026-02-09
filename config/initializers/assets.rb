# config/initializers/assets.rb

Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.css_compressor = nil

# Precompile Tailwind CSS and other key assets
Rails.application.config.assets.precompile += %w[
  tailwind.css
  application.css
  application.js
]

# Precompile all images in app/assets/images/
Dir.glob(Rails.root.join("app/assets/images/*")).each do |image_path|
  filename = File.basename(image_path)
  Rails.application.config.assets.precompile << filename
end

# include built assets (esbuild / Tailwind CLI output)
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "builds")
