require 'fileutils'

key_loc = Rails.root.join(ENV['BLOG_DEPLOY_KEY_LOCATION'])

File.write(key_loc, ENV['BLOG_GIT_SSH_PRIVATE_KEY'])
File.chmod(0600, key_loc)

if Rails.env.production?
  `mkdir -p $HOME/.ssh`
  `echo "Host bitbucket.org\n\tStrictHostKeyChecking no\n" > $HOME/.ssh/config`
end
