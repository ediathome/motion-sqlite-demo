# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
$:.unshift("~/.rubymotion/rubymotion-templates")

require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'motion-sqlite-demo'
  app.deployment_target = '10.13'
  app.info_plist['CFBundleIconName'] = 'AppIcon'

  app.pods do
    pod 'FMDB'
    pod 'SQLCipher'
  end
end
