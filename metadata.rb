name             'cookbook_pusher'
maintainer       'computerlyrik'
maintainer_email 'chef-cookbooks@computerlyrik.de'
license          'Apache 2.0'
description      'Automagically pushes your public cookbooks
                  from github to opscode community'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'

source_url 'https://github.com/computerlyrik/chef-cookbook_pusher'
depends           'git'
