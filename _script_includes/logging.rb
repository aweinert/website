# Taken from https://stackoverflow.com/a/16363159
class String
	def red;            "\e[31m#{self}\e[0m" end
	def green;          "\e[32m#{self}\e[0m" end
	def yellow;         "\e[33m#{self}\e[0m" end
	def underline;      "\e[4m#{self}\e[24m" end
	def reverse_color;  "\e[7m#{self}\e[27m" end
end

module Logging

	$successes_reported = 0
	$warnings_reported = 0
	$failures_reported = 0


	def assert_or_failure(condition, success_message, error_message)
		if condition.call then
			report_success(success_message)
		else
			report_failure(error_message)
		end
	end

	def assert_or_warning(condition, success_message, warning_message)
		if condition.call then
			report_success(success_message)
		else
			report_warning(warning_message)
		end
	end

	def report_status(message)
		puts message
	end

	def report_success(message)
		puts "    ✅ #{message}".green
		$successes_reported += 1
	end

	def report_warning(message)
		puts "    ⚠️  #{message}".yellow
		$warnings_reported += 1
	end

	def report_failure(message)
		puts "    ❌ #{message}".red
		$failures_reported += 1
	end

	def abort_if_failure()
		if $failure_reported then
			exit(false)
		end
	end

end
