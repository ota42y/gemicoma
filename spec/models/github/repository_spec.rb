require 'rails_helper'

RSpec.describe Github::Repository, type: :model do
  describe 'github_path' do
    subject { repository.github_path }

    let(:github_user) { build(:github_user) }
    let(:repository) { build(:github_repository, github_user: github_user) }

    it do
      expect(subject).to eq("#{github_user.name}/#{repository.repository}")
    end
  end
end
