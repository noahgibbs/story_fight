# Load the local gem first, even if installed.
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "minitest/autorun"
require "minitest/pride"

require "story_fight"
