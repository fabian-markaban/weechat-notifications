# See installation instructions at https://github.com/fabian-markaban/weechat-notifications
# Requires either 'terminal-notifier' gem or 'ruby_gntp' gem for Growl 1.3+ support
require 'rubygems'
require 'weechat'
include Weechat

def weechat_init
  Weechat.register("notifications",
                   "Fabian Markaban",
                   "0.0.9",
                   "GPL3",
                   "Weechat notfications through Notification Center or Growl 1.3+",
                   "",
                   "")

  load_notifier_gem
  hook_notifications

  return Weechat::WEECHAT_RC_OK
end

def load_notifier_gem
  if ! Gem::Specification::find_all_by_name('terminal-notifier').empty?
    
    @notifier_gem = "terminal-notifier"
    require @notifier_gem
  
  elsif ! Gem::Specification::find_all_by_name('ruby_gntp').empty?
    
    @notifier_gem = "ruby_gntp"
    require @notifier_gem

    @growl = GNTP.new("Weechat")
    @growl.register({ 
      :notifications => [
      {
        :name    => "Private",
        :enabled => true
      },
      {
        :name    => "Highlight",
        :enabled => true
      }]
    })
  end
end

def hook_notifications
  Weechat.hook_signal("weechat_pv", "show_private", "")
  Weechat.hook_signal("weechat_highlight", "show_highlight", "")
end

def unhook_notifications(data, signal, message)
  Weechat.unhook(show_private)
  Weechat.unhook(show_highlight)
end

def show_private(data, signal, message)
  message[0..1] == '--' ? sticky = false : sticky = true
  show_notification("Weechat Private Message",  message, sticky)
  return Weechat::WEECHAT_RC_OK
end

def show_highlight(data, signal, message)
  message[0..1] == '--' ? sticky = false : sticky = true
  show_notification("Weechat",  message, sticky)
  return Weechat::WEECHAT_RC_OK
end

def show_notification(title, message, sticky)
  case @notifier_gem 
  when "terminal-notifier"
    TerminalNotifier.notify(message, { :title  => title, :activate => "com.apple.Terminal", :sender => "com.apple.Terminal" })
  when "ruby_gntp"
    @growl.notify({
      :name   => name,
      :title  => title,
      :text   => message,
      #:icon   => "weechat.png",
      :sticky => sticky
    })
  else
     Weechat.print("", "Error: Either terminal-notifier or ruby_gntp needs to be installed as a gem (gem install terminal-notifier fe.)")
  end              
end