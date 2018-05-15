require 'rails_helper'

describe Github::Users::Repositories::UpdateJobsController, type: :request do
  describe '#create' do
    subject { post url }

    let(:url) { "/github/users/#{github_user.name}/repositories/#{repository.repository}/update_jobs" }

    context 'when correct params' do
      let(:github_user) { repository.github_user }
      let(:repository) { create(:github_repository) }

      it do
        expect { subject }.to have_enqueued_job(::FetchMasterJob).with(repository.id, true)

        expect(response.status).to eq 302
      end

      it 'check redirect' do
        expect(subject).to redirect_to("/github/users/#{github_user.name}/repositories/#{repository.repository}")
      end
    end
  end
end
