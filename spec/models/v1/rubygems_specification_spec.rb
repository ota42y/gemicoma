require 'rails_helper'

describe ::V1::RubygemsSpecification do
  before { stub_request(:get, "#{uri}specs.4.8.gz").to_return(body: gz_body) }

  let(:gz_body) { Gem::Util.gzip(Marshal.dump(gems)) }
  let(:gems) { [['rails', Gem::Version.create('6.0'), 'ruby']] }

  let(:uri) { ::V1::RubygemsLoader::DEFAULT_RUBYGEM_URI }
  let(:specification) { ::V1::RubygemsSpecification.new(uri) }

  describe 'all_specs' do
    subject { specification.all_specs }

    context 'correct data' do
      it do
        expect(subject).to eq gems
      end
    end
  end

  describe 'specs' do
    subject { specification.specs }

    let(:gems) do
      [
        ['rails', Gem::Version.create('5.1.0'), 'ruby'],
        ['rails', Gem::Version.create('6.0.0'), 'ruby'],
        ['rails', Gem::Version.create('5.0.1'), 'ruby'],
        ['another', Gem::Version.create('1.0.1'), 'another'],
        ['another', Gem::Version.create('1.0.0'), 'ruby'],
      ]
    end

    context 'correct data' do
      it do
        expect(subject['ruby']['rails'].size).to eq 3
        expect(subject['ruby']['rails'].first).to eq Gem::Version.create('6.0.0')
        expect(subject['another']['another'].first).to eq Gem::Version.create('1.0.1')
        expect(subject['none']['none'].first).to eq nil
      end
    end
  end

  describe 'latest_spec' do
    subject { specification.newest_version(name, platform) }

    let(:gems) do
      [
        ['rails', Gem::Version.create('5.1.0'), 'ruby'],
        ['rails', Gem::Version.create('6.0.0'), 'ruby'],
        ['rails', Gem::Version.create('5.0.1'), 'ruby'],
        ['another', Gem::Version.create('1.0.1'), 'another'],
        ['another', Gem::Version.create('1.0.0'), 'ruby'],
      ]
    end

    using RSpec::Parameterized::TableSyntax

    where(:name, :platform, :result) do
      'rails' | 'ruby' | Gem::Version.create('6.0.0')
      'rails' | 'no_platform' | nil
      'unknown' | 'ruby' | nil
      'another' | 'another' | Gem::Version.create('1.0.1')
    end

    with_them do
      it { expect(subject).to eq result }
    end
  end
end
