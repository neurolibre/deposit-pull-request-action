require "octokit"

def gh_token
  gh_token_from_env = ENV['BOT_TOKEN'].to_s.strip
  gh_token_from_env = ENV['GH_ACCESS_TOKEN'].to_s.strip if gh_token_from_env.empty?
  raise "!! ERROR: Invalid GitHub Token" if gh_token_from_env.empty?
  gh_token_from_env
end

def github_client
  @github_client ||= Octokit::Client.new(access_token: gh_token, auto_paginate: true)
end

issue_id = ENV["ISSUE_ID"]
papers_repo = ENV["PAPERS_REPO"]
papers_repo_main_banch = ENV["PAPERS_REPO_MAIN_BRANCH"] || "main"
branch_prefix = ENV["BRANCH_PREFIX"]
mode = ENV["MODE"].to_s.downcase == "deposit" ? "deposit" : "dry-run"

id = "%05d" % issue_id
branch = branch_prefix.empty? ? id.to_s : "#{branch_prefix}.#{id}"

gh_response = github_client.create_pull_request(papers_repo, papers_repo_main_banch, "#{branch}",
  "Creating pull request for 10.55458.#{branch}", "If this looks good then :shipit:")

if mode == "deposit"
  sleep(5)
  github_client.merge_pull_request(papers_repo, gh_response.number, "Merging automatically")
  github_client.delete_ref(papers_repo, "heads/#{branch}")
end

system("echo 'pr_url=#{gh_response.html_url}' >> $GITHUB_OUTPUT")
