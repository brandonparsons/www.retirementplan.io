task post_metrics: [:post_split_experiments]

desc "Collects data on running A/B tests and posts results to slack"
task post_split_experiments: :environment do
  ReportSplitExperimentsToSlack.new.perform
end
