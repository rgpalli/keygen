#
# Cookbook Name:: schl_keygen
# Providers:: ssh
#
# Copyright 2014, Scholastic PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

action :add do

	directory "#{new_resource.user_home}/.ssh" do
		owner new_resource.username
  		group new_resource.groupname
  		recursive true
  		mode 00755
  		action :create
  	end

	template "#{new_resource.user_home}/#{new_resource.keygen_file}" do
		source "keygen.rb.erb"
		mode 00755
		owner "#{new_resource.username}"
  		group "#{new_resource.groupname}"
		cookbook 'schl_keygen'
  		variables({
	                :fileloc => "#{new_resource.user_home}/.ssh/id_rsa"
	            })
  		not_if { ::File.exists? ("#{new_resource.user_home}/.ssh/id_rsa") }
  		action :create
  	end

	execute "./#{new_resource.keygen_file}" do
		cwd  "#{new_resource.user_home}"
		user "#{new_resource.username}"
		group "#{new_resource.groupname}"
		not_if { ::File.exists? ("#{new_resource.user_home}/.ssh/id_rsa") }
	end

	template "#{new_resource.user_home}/#{new_resource.ssh_file}" do
		source "ssh_copy.rb.erb"
		cookbook 'schl_keygen'
		owner "#{new_resource.username}"
		group "#{new_resource.groupname}"
		variables({
					:fileloc => "#{new_resource.user_home}/.ssh/id_rsa.pub",
					:user => "#{new_resource.username}",
					:password => "#{new_resource.userpswd}",
					:server => "#{new_resource.sshhost}"
				})
		mode 0744
		action :create
		not_if { ::File.exists? ("#{new_resource.user_home}/.ssh/#{new_resource.sshhost}") }
	end

	execute "./#{new_resource.ssh_file}" do
		cwd  "#{new_resource.user_home}"
		user "#{new_resource.username}"
		group "#{new_resource.groupname}"
		not_if { ::File.exists? ("#{new_resource.user_home}/.ssh/#{new_resource.sshhost}") }
	end

	file "#{new_resource.user_home}/.ssh/#{new_resource.sshhost}" do
		user "#{new_resource.username}"
		group "#{new_resource.groupname}"
		action :create
       	not_if { ::File.exists? ("#{new_resource.user_home}/.ssh/#{new_resource.sshhost}") }
   	end

	["#{new_resource.ssh_file}", "#{new_resource.keygen_file}"].each do|file|

    	file "#{new_resource.user_home}/#{file}" do
        	action :delete
        	# only_if { ::File.exists? ("#{new_resource.user_home}/#{file}") }
    	end
	end

end


action :nothing do
	#NOTHING
end