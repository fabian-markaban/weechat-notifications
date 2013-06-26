Installation 
------------

Weechat must be built with the ruby option enabled, if using homebrew:

    $ brew install weechat --with-ruby
    
Install terminal-notifier or ruby_gntp:    
    
    $ gem install weechat terminal-notifier 
    or 
    $ gem install weechat ruby_gntp

Download weechat-notifcations from this repo:

    $ mkdir -p ~/.weechat/ruby/autoload && cd ~/.weechat/ruby/autoload
    $ git clone git@github.com:fabian-markaban/weechat-notifications.git weechat-notifications && ln -s weechat-notifications/notifications.rb notifications.rb