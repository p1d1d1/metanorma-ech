source "https://rubygems.org"

# Load both local gemspecs directly from their folders
gemspec path: "metanorma-ech"
gemspec path: "isodoc-ech"

# Override the isodoc-ech dependency so it resolves locally
# instead of trying to fetch from RubyGems
gem "isodoc-ech", path: "isodoc-ech"

gem "metanorma-cli"
gem "rspec"
gem "rubocop"
