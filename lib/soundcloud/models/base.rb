module Soundcloud
  module Models
    class Base < OAuthActiveResource::Resource
      self.site = 'http://api.soundcloud.com'
      
    # has_many_unbulky_changeable and can_be_an_unbulky_changeable is used in combination with has_many.
    #
    # it expects to have a resource http://example.com/me which is the logged-in user.
    #
    # Example:
    # like in self.has_many you have a resource user with a sub resource friends,
    # but its not allowed to send a PUT /me/friends to update the list of friends
    # instead to add or remove a friend you send a GET/PUT/DELETE to /me/friends/{user_id}
    #   class User < Resource
    #     has_many :friends
    #     can_be_an_unbulky_changeable :friend
    #     has_many_unbulky_changeable :friends
    #   end
    #
    #   me = User.find(:one, :from => '/me')
    #   friend = me.friends.first
    #   stranger = User.find(235)
    # 
    #   friend.is_friend?
    #  => true
    #   stranger.is_friend?
    #  => false
    #
    #   strange.add_friend!
    #   stranger.is_friend?
    #  => true
    #
    #   stranger.remove_friend!
    #   stranger.is_friend?
    #  => false    
    #
    #   friend.has_friend?(stranger.id)
    #  => checks if stranger and friend are friend, returns true or false
    
    def self.can_be_an_unbulky_changeable(*args)
      args.each do |k| 
        singular = k.to_s
        define_method("is_#{singular}?") do
          begin
            self.connection.get_without_decoding "/me/#{singular.pluralize}/#{self.id}"
            return true
          rescue ActiveResource::ResourceNotFound
            return false
          end
        end
        
        define_method("add_#{singular}!") do
        p "add #{singular}"
        p "/me/#{singular.pluralize}/#{self.id}"
          self.connection.put "/me/#{singular.pluralize}/#{self.id}"
        end                    

        define_method("remove_#{singular}!") do
          self.connection.delete "/me/#{singular.pluralize}/#{self.id}"
        end                
      end    
    end

    # see can_be_an_unbulky_changeable        
    def self.has_many_unbulky_changeable(*args)
      args.each do |k| 
        singular = k.to_s.singularize
        define_method("has_#{singular}?") do |look_for_id|
          begin
            self.connection.get_without_decoding "/#{self.element_name.pluralize}/#{self.id}/#{singular.pluralize}/#{look_for_id}"
            return true
          rescue ActiveResource::ResourceNotFound
            return false
          end          
        end
      end    
    end
    
    
          
    end
  end
end
