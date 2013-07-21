require 'grit-ext'
require 'pronto/plugin'
require 'pronto/message'
require 'pronto/runner'

module Pronto
  def self.register_runner(runner)
    @runners ||= []
    @runners << runner
  end

end
