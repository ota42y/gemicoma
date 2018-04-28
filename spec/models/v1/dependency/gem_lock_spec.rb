require 'rails_helper'

describe ::V1::Dependency::GemLock do
  it 'the truth' do
    body = open('./Gemfile.lock').read
    lock = ::V1::Dependency::GemLock.create_from_gemfile_lock(body)
    expect(lock.specifications.empty?).to eq false
  end
end
