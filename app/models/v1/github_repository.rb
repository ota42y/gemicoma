module V1
  class GithubRepository
    class << self
      # @return [string]
      def contents_by_string(repository_path, path, commit_hash)
        response = client.contents(repository_path, path: path, ref: commit_hash)
        Base64.decode64(response.content)
      end

      private

        # @return [Octokit::Client]
        def client
          ::Octokit::Client.new
        end
    end
  end
end
