require 'acts_as_referred/instance_methods'
require 'acts_as_referred/model'
require 'acts_as_referred/class_methods'
require 'acts_as_referred/controller'

module ActsAsReferred
  extend ActiveSupport::Concern
  
  included do
  end

  # provide rake-tasks to create db-migration
  class RakeTasks < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end

end

ActiveRecord::Base.send :include, ActsAsReferred
