require 'test_helper'

class ::V1::Dependency::GemLockTest < ActiveSupport::TestCase
  test 'the truth' do
    body = open('./Gemfile.lock').read
    lock = ::V1::Dependency::GemLock.create_from_gemfile_lock(body)
    assert_not_empty lock.specifications
  end
end
