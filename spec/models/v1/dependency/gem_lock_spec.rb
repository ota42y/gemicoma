require 'rails_helper'

describe ::V1::Dependency::GemLock do
  context 'correct' do
    include_context 'shared_gemfile_text'

    it do
      lock = ::V1::Dependency::GemLock.create_from_gemfile_lock(gemfile_text)
      expect(lock.specifications.empty?).to eq false
    end
  end
end
