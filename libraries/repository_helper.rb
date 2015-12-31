require 'octokit'

module RepositoryHelper
  def process_repositories(repositories, path)
    repositories.each do |repo|

      Chef::Log.info('processing '+repo.name)

      if repo.name =~ /^chef-/

        if repo.fork
          Chef::Log.warn(repo.name + ' is a fork, not publishing')
          next
        end

        name = repo.name[/chef-(.*)/, 1]
        category = repo.description[/\|\ Category:\ (.*)$/, 1]
        if category.nil?
          Chef::Log.warn('no category found for ' + repo.name)
          next
        end

        Chef::Log.info('sharing ' + repo.name + ' as ' + name +
                        ' into category ' + category)

        git "#{path}/cookbooks/#{name}" do
          repository repo.clone_url
          action :sync
          notifies :run,"execute[upload_#{name}]", :immediately
        end
        Chef::Log.info("knife cookbook site share #{name} #{category} -c #{path}/knife.rb")
        execute "upload_#{name}" do
          command "knife cookbook site share #{name} #{category} -c #{path}/knife.rb"
          action :nothing
          ignore_failure true
        end
      end
    end
  end
  def push(query)
    response = Octokit.search_repositories(query)
    loop do 
      #Chef::Log.info(Octokit.last_response)
      process_repositories(response.items, node['cookbook_pusher']['path'])
      break if response.rels[:next].nil?
      response = response.rels[:next].get
    end 
  end
end
