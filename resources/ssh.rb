#
# Cookbook Name:: schl_keygen
# Resources:: ssh
#
# Copyright 2014, Scholastic PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

actions :add, :nothing
default_action :add

attribute :name, :kind_of => String, :name_attribute => true
attribute :username, :kind_of => String
attribute :groupname, :kind_of => String
attribute :user_home, :kind_of => String
attribute :keygen_file, :kind_of => String, :required => true
attribute :ssh_file, :kind_of => String, :required => true
attribute :sshhost, :kind_of => String, :required => true
attribute :userpswd, :kind_of => String, :required => true


def initialize(*args)
  super
  @action = :add
end