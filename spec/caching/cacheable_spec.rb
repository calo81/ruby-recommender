require_relative '../../spec/spec_helper'
require_relative '../../lib/caching/cacheable'

class SimpleCacheableUse
  include Cacheable

  def method1(value)
    "anything works"
  end

  def method2(value)
    "anything works"
  end

  def method3

  end

  def method4

  end

  cacheable :method1
end

describe "Cacheable" do
  it "should cache things forever with simplest use when activating caching" do
    object = SimpleCacheableUse.new
    object.activate_cache
    value_1 = object.method1("x")
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_true
  end

  it "should not cache things if cache not active" do
    object = SimpleCacheableUse.new
    value_1 = object.method1("x")
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_false
  end

  it "should not cache things if cache active and then not active" do
    object = SimpleCacheableUse.new
    object.activate_cache
    value_1 = object.method1("x")
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_true
    object.deactivate_cache
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_false
  end

  it "should not cache things in no cacheable methods" do
    object = SimpleCacheableUse.new
    object.activate_cache
    value_1 = object.method2("x")
    value_2 = object.method2("x")
    value_1.equal?(value_2).should be_false
  end

  it "should refresh the cache when refresh method configured is called" do
    object = SimpleCacheableUse.new
    object.activate_cache
    value_1 = object.method1("x")
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_true
    object.refresh_cache(:method1)
    value_2 = object.method1("x")
    value_1.equal?(value_2).should be_false
  end

end