require 'test_helper'

class ::V1::Dependency::GemLockTest < ActiveSupport::TestCase
  test 'the truth' do
    file = open('./Gemfile.lock')
    body = file.read
    lock = ::V1::Dependency::GemLock.new(body)
    assert_not_empty lock.specs
  end
end
