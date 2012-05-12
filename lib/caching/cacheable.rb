module Cacheable
  module ClassMethods
    def define_cached_method(method)
      define_method(method.to_sym) do |*args|
        return self.send("uncached_#{method}", args) unless @caching_active
        @cached ||= {}
        return @cached[method.to_s+args.to_s] if @cached[method.to_s+args.to_s]
        value = self.send("uncached_#{method}", args)
        @cached[method.to_s+args.to_s] = value
        return value
      end
    end

    def cacheable(*methods)
      methods.each do |method|
        alias_method :"uncached_#{method}", method.to_sym
        define_cached_method(method)
      end
    end
  end

  def activate_cache
    @caching_active = true
  end

  def deactivate_cache
    @caching_active = false
  end

  def self.included(host_class)
    host_class.extend(ClassMethods)
  end
end