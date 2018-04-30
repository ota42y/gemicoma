module V1
  module Github
    class GemData
      # @param [Github::Commit] commit
      def initialize(commit)
        @commit = commit
      end
    end
  end
end
