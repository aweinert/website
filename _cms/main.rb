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

class Photo
	def initialize(path)
		@path = path
		size = FastImage.size(path)
		@width = size[0]
		@height = size[1]
	end

	def get_path()
		return @path
	end

	def get_width()
		return @width
	end

	def get_height()
		return @height
	end

	def is_landscape()
		# We treat square photos as portraits
		return @width > @height
	end

	def resize_and_compress(longest_edge, quality, to)
		input_option = {}
		output_option = {
			"resize" => "#{longest_edge}x#{longest_edge}",
			"quality" => "#{quality}%"
		}
		ImageMagick.convert(input_option, @path, output_option, to)

		return Photo.new(to)
	end

	def add_watermark(watermark, wm_position_calc, target)
		params = {
			"watermark" => "30%",
			"gravity" => "southeast",
			"geometry" => "#{wm_position_calc.get_width}x+#{wm_position_calc.get_offset_x}+#{wm_position_calc.get_offset_y}"
		}
		ImageMagick.composite(watermark.get_path, @path, target, params)

		return Photo.new(target)
	end
end

class WatermarkPositionCalculator
	def initialize(watermark, image)
		@watermark = watermark
		@image = image
	end

	# Returns the width the watermark shall be displayed at in px
	def get_width()
		if(@image.is_landscape)
			return @image.get_width / 4.0
		else
			return @image.get_width / 3.5
		end
	end

	def get_height() 
		self.get_width / @watermark.get_width * @watermark.get_height
	end

	def get_offset_x()
		if @image.is_landscape
			return @image.get_width * 1 / 8
		else
			return @image.get_width * 1 / 4
		end
	end

	def get_offset_y()
		if @image.is_landscape
			return self.get_height
		else
			return @image.get_height * 1 / 5
		end
	end
end

class PhotoDB
	def prependPhoto(thumbnail_path, fullpic_path, photo_id, caption)
		# Copy the photo to the assets-folder
		Files.copy_file(thumbnail_path, "../assets/img/thumb/#{photo_id}.jpg")
		Files.copy_file(fullpic_path, "../assets/img/full/#{photo_id}.jpg")

		# Register the new photo with the photography.yml file
		temp_path = Files.get_temp_path()
		File.open(temp_path, 'a') do |file|
			file << "- path: #{photo_id}.jpg\n"
			file << "  title: #{caption}\n"
			file << File.read("../_data/photography.yml")
		end

		Files.copy_file(temp_path, "../_data/photography.yml")
		Files.remove_file(temp_path)
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

	def watermark(path, id)
		image = Photo.new(path)

		basename = id
		Files.make_dir(basename)
		retval = {}
		@config.each do |pair|
			config_id = pair[0]
			current_config = pair[1]

			temp_path = Files.get_temp_path()
			if current_config[:watermark] != nil
				watermark = Photo.new(current_config[:watermark])
				wm_position_calc = WatermarkPositionCalculator.new(watermark, image)
				watermarked_image = image.add_watermark(watermark, wm_position_calc, temp_path)
			else 
				Files.copy_file(image.get_path, temp_path)
				watermarked_image = Photo.new(temp_path)
			end

			target_path = "#{basename}/#{basename}-#{current_config[:suffix]}.jpg"
			watermarked_image.resize_and_compress(current_config[:longest_edge], current_config[:quality], target_path)
			Files.remove_file(watermarked_image.get_path)
			retval[config_id] = target_path
		end
		return retval
	end

	def main(photo_db)
		id = ask("ID? (short name that the photograph is referred to internally)")
		title = ask("Title? (shown below the photograph)")
		path = ask("Path to the original photograph?")
		paths = watermark(path, id)

		photo_db.prependPhoto(paths[:thumb], paths[:alexanderweinert], id, title)
	end
end

def main()
	choose do |menu|
		menu.prompt = "What would you like to edit?"

		menu.choices(:Photography) { 
			Photography.new().main(PhotoDB.new())
		}
	end
end

main()
