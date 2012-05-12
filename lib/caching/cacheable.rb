module Cacheable
  module ClassMethods
    def define_cached_method(method)
      define_method(method.to_sym) do |*args|
        return self.send("uncached_#{method}", *args) unless @caching_active
        @cached ||= {}
        @cached_methods_particulars ||= {}
        return @cached[method.to_s+args.hash.to_s] if @cached[method.to_s+args.hash.to_s]
        value = self.send("uncached_#{method}", *args)
        @cached[method.to_s+args.hash.to_s] = value
        (@cached_methods_particulars[method] ||= []) <<  method.to_s+args.hash.to_s
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

  def refresh_cache(*methods)
    raise "Cache is not active." unless @caching_active
    methods.each do |method|
      @cached_methods_particulars[method].each do |cached_values|
        @cached[cached_values] = nil
      end
    end
  end

  def self.included(host_class)
    host_class.extend(ClassMethods)
  end
end