require 'RMagick'
include Magick

$photos = []

module Jekyll
	class RenderPhotoTag < Liquid::Tag
		def initialize(tag_name, path, tokens)
			super
			@path = path.strip
		end

		def render(context)
			$photos.push(@path)

			"<img src=\"/assets/img/thumb/#{@path}\"/>"
		end
	end
end

Liquid::Template.register_tag('photo', Jekyll::RenderPhotoTag)
Jekyll::Hooks.register :site, :post_write { |site, hash|
	$photos.each do |path|
		puts "Resizing #{path}"
		image = ImageList.new("_assets/img/#{path}").first
		image.resize_to_fit(1000, 1000).write("_site/assets/img/full/#{path}")

		image = ImageList.new("_assets/img/#{path}").first
		image.resize_to_fit(300, 300).write("_site/assets/img/thumb/#{path}")
	end
}
