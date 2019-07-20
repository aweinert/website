require 'RMagick'
require 'Set'
include Magick
require 'yaml'

require_relative '../_script_includes/logging'
include Logging

$photos = Set.new

def get_full_path_display(photo_id); "_assets/img/#{photo_id}".underline end
def get_scaled_paths_display(photo_id); "assets/img/{full,thumb}/#{photo_id}".underline end
def get_scaled_full_path_display(photo_id); "assets/img/full/#{photo_id}".underline end
def get_scaled_thumb_path_display(photo_id); "assets/img/thumb/#{photo_id}".underline end

YAML_FILE = '_data/photography.yml'


module AlexanderWeinertNet
	module Photography
		module Filter
			def photo_path_full(photo_id)
				$photos.add(photo_id)
				"/assets/img/full/#{photo_id}"
			end

			def photo_path_thumb(photo_id)
				$photos.add(photo_id)
				"/assets/img/thumb/#{photo_id}"
			end
		end

		def post_site_read(site, hash)

			data = YAML.load_file(YAML_FILE)

			report_status("Loaded #{YAML_FILE}")

			report_status("Checking syntax of #{YAML_FILE}")
			if not data.kind_of?(Array) then
				report_error("#{YAML_FILE} does not contain an array at top level")
			end

			abort_if_failure()

			data.each { |item| 
				if not item.kind_of?(Hash) then
					report_failure("Entry #{item} is not a dictionary")
					next
				end

				if not item.key?('id') then
					report_failure("Entry #{item} does not contain a key 'path'")
				end

				if not item['id'].kind_of?(String) then
					report_failure("Item #{item}: Value for key 'id' is not a String, but a #{item['path'].class}")
				end

				if not item.key?('title') then
					report_failure("Entry #{item} does not contain a key 'title'")
				end

				if not item['title'].kind_of?(String) then
					report_failure("Item #{item}: Value for key 'title' is not a String, but a #{item['path'].class}")
				end

				actual_keys = Set.new item.keys
				expected_keys = Set.new ['id', 'title']

				if not actual_keys == expected_keys then
					report_warning("Item #{item} contains unexpected keys: #{(actual_keys - expected_keys).inspect()}")
				end
			}

			report_success("#{YAML_FILE} is syntactically correct")

			report_status("Checking images referenced in #{YAML_FILE}")

			data.each { |item| 
				photo_id = item['id']

				original_exists = File.file?("_assets/img/#{photo_id}")
				if not original_exists then
					error_message = "#{YAML_FILE} references photo #{photo_id}. For this, an original (_assets/img/#{photo_id}) does not exist."
				end
			}

			if $failures_reported == 0 then
				report_success("All images referenced in #{YAML_FILE} exist")
			end

			all_photos = Set.new Dir.glob("_assets/img/*.jpg").map { |x| File.basename(x) }
			referenced_photos = data.select { |x| x.key?('id') }.map { |x| x['id'] }

			all_photos.each { |photo_id| 
				if not referenced_photos.include?(photo_id) then
					warning_message ="The photo #{photo_id} is present as full version (#{get_full_path_display(photo_id)}), but not referenced in #{YAML_FILE}"
					report_warning(warning_message)
				end
			}
		end

		def post_site_write(site, hash)
			$photos.each do |path|
				image = ImageList.new("_assets/img/#{path}").first
				image.resize_to_fit(1000, 1000).write("_site/assets/img/full/#{path}") { self.quality = 90 }

				image = ImageList.new("_assets/img/#{path}").first
				image.resize_to_fit(360, 360).write("_site/assets/img/thumb/#{path}") { self.quality = 90 }
			end
		end
	end
end

include AlexanderWeinertNet::Photography

Liquid::Template.register_filter(AlexanderWeinertNet::Photography::Filter)

Jekyll::Hooks.register :site, :post_read { |site, hash|
	AlexanderWeinertNet::Photography::post_site_read(site, hash)
}

Jekyll::Hooks.register :site, :post_write { |site, hash|
	AlexanderWeinertNet::Photography::post_site_write(site, hash)
}
