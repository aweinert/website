require 'RMagick'
include Magick

$photos = []

module AlexanderWeinertNet
	module Photography
		module Filter
			def photo_path_full(photo_id)
				$photos.push(photo_id)
				"/assets/img/thumb/#{photo_id}"
			end

			def photo_path_thumb(photo_id)
				$photos.push(photo_id)
				"/assets/img/full/#{photo_id}"
			end
		end

		def post_site_write(site, hash)
			$photos.each do |path|
				image = ImageList.new("_assets/img/#{path}").first
				image.resize_to_fit(1000, 1000).write("_site/assets/img/full/#{path}")

				image = ImageList.new("_assets/img/#{path}").first
				image.resize_to_fit(300, 300).write("_site/assets/img/thumb/#{path}")
			end
		end
	end
end

include AlexanderWeinertNet::Photography

Liquid::Template.register_filter(AlexanderWeinertNet::Photography::Filter)

Jekyll::Hooks.register :site, :post_write { |site, hash|
	AlexanderWeinertNet::Photography::post_site_write(site, hash)
}
