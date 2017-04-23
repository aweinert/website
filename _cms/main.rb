#!/usr/bin/ruby

require 'fastimage'
require 'highline/import'
require 'fileutils'

module Files
	def Files.copy_file(from, to)
		system("cp #{from} #{to}")
	end

	def Files.get_temp_path()
		return "temp.jpg"
	end

	def Files.make_dir(name)
		system("mkdir #{name}")
	end

	def Files.remove_file(path)
		system("rm #{path}")
	end
end

module ImageMagick
	def ImageMagick.composite(change_file, base_file, output_image, params)
		call = "composite "
		params.each do |pair|
			call += "-#{pair[0]} #{pair[1]} "
		end

		call += "#{change_file} #{base_file} #{output_image}"
		system(call)
	end

	def ImageMagick.convert(input_option, input_file, output_option, output_file)
		call = "convert "
		input_option.each do |pair|
			call += "-#{pair[0]} #{pair[1]} "
		end
		call += "#{input_file} "
		output_option.each do |pair|
			call += "-#{pair[0]} #{pair[1]} "
		end
		call += "#{output_file}"
		system(call)
	end
end


class Photography
	def initialize()
		@config = {
			:thumb => {
				:suffix => "thumb",
				:watermark => nil,
				:quality => 90,
				:longest_edge => 300
			},
			:alexanderweinert => {
				:suffix => "aw",
				:watermark => "wm-aw.png",
				:quality => 90,
				:longest_edge => 1000
			},
			:facebook => {
				:suffix => "fb",
				:watermark => "wm-fb.png",
				:quality => 90,
				:longest_edge => 1000
			},
			:fivehundredpx => {
				:suffix => "500px",
				:watermark => "wm-500px.png",
				:quality => 90,
				:longest_edge => 1000
			}
		}
	end

	def add_watermark(input, watermark, wm_position, target)
		params = {
			"watermark" => "30%",
			"gravity" => "southeast",
			"geometry" => "#{wm_position[:width]}x+#{wm_position[:offset_x]}+#{wm_position[:offset_y]}"
		}
		ImageMagick.composite(watermark[:path], input[:path], target, params)
	end



	def resize_and_compress(from, longest_edge, quality, to)
		input_option = {}
		output_option = {
			"resize" => "#{longest_edge}x#{longest_edge}",
			"quality" => "#{quality}%"
		}
		ImageMagick.convert(input_option, from, output_option, to)
	end

	def parse_image(path)
		size = FastImage.size(path)
		return { :path => path, :width => size[0], :height => size[1] }
	end

	def is_landscape(image)
		# We treat square photos as portraits
		return image[:width] > image[:height]
	end

	def get_wm_position(watermark, image)
		def landscape(watermark, image)
			wm_target_width = image[:width] / 4.0
			wm_target_height = wm_target_width / watermark[:width] * watermark[:height]
			wm_target_offset_x = image[:width] * 1 / 8
			wm_target_offset_y = wm_target_height * 1
			return { :width => wm_target_width.to_i, :offset_x => wm_target_offset_x.to_i, :offset_y => wm_target_offset_y.to_i }
		end

		def portrait(watermark, image)
			wm_target_width = image[:width] / 3.5
			wm_target_offset_x = image[:width] * 1 / 4
			wm_target_offset_y = image[:height] * 1 / 5
			return { :width => wm_target_width.to_i, :offset_x => wm_target_offset_x.to_i, :offset_y => wm_target_offset_y.to_i }
		end

		if is_landscape(image)
			return landscape(watermark, image)
		else
			return portrait(watermark, image)
		end
	end

	def watermark(path, id)
		image = parse_image(path)

		basename = id
		Files.make_dir(basename)
		retval = {}
		@config.each do |pair|
			current_config = pair[1]

			temp_path = Files.get_temp_path()
			if current_config[:watermark] != nil
				watermark = parse_image(current_config[:watermark])
				wm_position = get_wm_position(watermark, image)
				add_watermark(image, watermark, wm_position, temp_path)
			else 
				Files.copy_file(image[:path], temp_path)
			end

			target_path = "#{basename}/#{basename}-#{current_config[:suffix]}.jpg"
			resize_and_compress(temp_path, current_config[:longest_edge],current_config[:quality], target_path)
			Files.remove_file(temp_path)
			retval[pair[0]] = target_path
		end
		return retval
	end

	def main()
		id = ask("ID? (short name that the photograph is referred to internally)")
		title = ask("Title? (shown below the photograph)")
		path = ask("Path to the original photograph?")
		paths = watermark(path, id)
		Files.copy_file(paths[:thumb], "../assets/img/thumb/#{id}.jpg")
		Files.copy_file(paths[:alexanderweinert], "../assets/img/full/#{id}.jpg")

		temp_path = Files.get_temp_path()
		File.open(temp_path, 'a') do |file|
			file << "- path: #{id}.jpg\n"
			file << "  title: #{title}\n"
			file << File.read("../_data/photography.yml")
		end

		Files.copy_file(temp_path, "../_data/photography.yml")
		Files.remove_file(temp_path)
	end
end

def main()
	choose do |menu|
		menu.prompt = "What would you like to edit?"

		menu.choices(:Photography) { 
			Photography.new().main
		}
	end
end

main()
