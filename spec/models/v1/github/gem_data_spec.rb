require 'rails_helper'

describe V1::Github::GemData, type: :model do
  describe 'execute' do
    subject { V1::Github::GemData.new(revision) }

    context 'get gemfile from github' do
      include_context 'shared_gemfile_text'

      let(:revision) do
        c = build(:revision, repository: create(:github_repository))
        c.repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c.save!
        c
      end

      before do
        stub_request(:get, "https://raw.githubusercontent.com/rails/rails/#{revision.commit_hash}/Gemfile.lock").
          to_return(body: gemfile_text)
      end

      it do
        expect(subject.build!).to eq true
        expect { subject.save! }.to change(::Revision::Ruby::Specification, :count).by(2)

        gemfile_lock = subject.gemfile_lock
        gem = gemfile_lock.specifications.select { |n| n.name == 'ota42y_rubygems_hands_on' }
        expect(gem[0].platform).to eq 'ruby'
        expect(gem[0].version).to eq '0.1.2'

        revision.reload
        expect(revision.revision_ruby_specifications.size).to eq 2
      end
    end
  end
end
