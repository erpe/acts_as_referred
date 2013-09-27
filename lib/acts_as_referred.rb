require 'acts_as_referred/instance_methods'
require 'acts_as_referred/rake_tasks'
require 'acts_as_referred/model'
require 'acts_as_referred/class_methods'
require 'acts_as_referred/controller'

module ActsAsReferred
  extend ActiveSupport::Concern
  
  included do
  end

end

ActiveRecord::Base.send :include, ActsAsReferred
