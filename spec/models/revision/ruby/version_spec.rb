require 'rails_helper'

RSpec.describe Revision::Ruby::Version, type: :model do
  describe 'validation' do
    subject { Revision::Ruby::Version.new(revision_dependency_file: revision_dependency_file, version: version).valid? }

    let(:revision_dependency_file) { build(:revision_dependency_file) }

    context 'valid' do
      let(:version) { '2.5.0' }
      it { expect(subject).to eq true }
    end

    context 'invalid' do
      let(:version) { '2.5.0a' }
      it { expect(subject).to eq false }
    end

    context 'invalid first' do
      let(:version) { 'a2.5.0' }
      it { expect(subject).to eq false }
    end
  end
end
