require 'rails_helper'

describe ::V1::RubygemsLoader do
  before do
    ::V1::RubygemsLoader.instance_variable_set(:@use_cache, true)
    ::V1::RubygemsLoader.instance_variable_set(:@cache, {})
  end

  after do
    ::V1::RubygemsLoader.instance_variable_set(:@use_cache, false)
    ::V1::RubygemsLoader.instance_variable_set(:@cache, {})
  end

  describe 'default_rubygems' do
    subject { ::V1::RubygemsLoader.default_rubygems }

    it do
      expect(subject.kind_of?(::V1::RubygemsSpecification)).to eq true
    end
  end

  describe 'update cache' do
    it do
      now = Time.current

      old_rubygems = nil
      travel_to now do
        old_rubygems = ::V1::RubygemsLoader.default_rubygems
      end

      travel_to now + ::Constants::RUBYGEMS::CACHE_TIME do
        expect(old_rubygems.object_id).to eq ::V1::RubygemsLoader.default_rubygems.object_id
      end

      travel_to now + ::Constants::RUBYGEMS::CACHE_TIME + 1.second do
        expect(old_rubygems.object_id).not_to eq ::V1::RubygemsLoader.default_rubygems.object_id
      end
    end

    it 'not use cache' do
      ::V1::RubygemsLoader.instance_variable_set(:@use_cache, false)

      travel_to Time.current do
        old_rubygems = ::V1::RubygemsLoader.default_rubygems
        expect(old_rubygems.object_id).not_to eq ::V1::RubygemsLoader.default_rubygems.object_id
      end
    end
  end
end
