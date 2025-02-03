require 'savon'
require 'anmat/constants'


module Anmat
  class Error < StandardError; end

  def self.root
  	File.expand_path '../..', __FILE__
	end

	autoload :Traceability,   "anmat/traceability"
end
