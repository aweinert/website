require 'RMagick'
include Magick

$photos = []

module Jekyll
	module PhotoPortfolioFilter
		def photo_path_full(photo_id)
			$photos.push(photo_id)
			"/assets/img/thumb/#{photo_id}"
		end

		def photo_path_thumb(photo_id)
			$photos.push(photo_id)
			"/assets/img/full/#{photo_id}"
		end
	end
end

Liquid::Template.register_filter(Jekyll::PhotoPortfolioFilter)

Jekyll::Hooks.register :site, :post_write { |site, hash|
	$photos.each do |path|
		image = ImageList.new("_assets/img/#{path}").first
		image.resize_to_fit(1000, 1000).write("_site/assets/img/full/#{path}")

		image = ImageList.new("_assets/img/#{path}").first
		image.resize_to_fit(300, 300).write("_site/assets/img/thumb/#{path}")
	end
}
