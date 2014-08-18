class ReportSplitExperimentsToSlack

  ## This would be best as recurring with sidetiq/sidekiq, but using suckerpunch
  ## on www site right now. Just queue up using heroku cron.
  ## If you change it to a recurring task, remove lib/tasks/post_metrics.rake (
  ## unless other stuff in there).
  # include SuckerPunch::Job

  def perform
    active_experiments = Split::Experiment.all.select{ |exp| exp.winner.nil? }
    active_experiments.each do |experiment|
      attachments = []
      experiment.alternatives.each do |alternative|
        attachments.push({
          fallback: "Experiment data not shown in this client.",
          pretext: "Alternative status:",
          color: alternative.to_s == experiment.winner.to_s ? "good" : "#222222",
          fields: [
            {
              title: "Alternative",
              value: alternative.name,
              short: true
            },
            {
              title: "Participants",
              value: alternative.participant_count,
              short: true
            },
            {
              title: "Completed",
              value: alternative.completed_count,
              short: true
            },
            {
              title: "Conversion Rate",
              value: conversion_rate(alternative, experiment),
              short: true
            },
            {
              title: "Confidence",
              value: confidence_level(alternative.z_score),
              short: true
            }
          ]
        })
      end
      message = "Active experiment: #{experiment.name}"
      Slack.new.post_message(message: message, attachments: attachments, channel: '#metrics')
    end
  end

  def conversion_rate(alternative, experiment)
    [number_to_percentage(round(alternative.conversion_rate, 3)), diff_percent(experiment, alternative)].compact.join(' ')
  end

  def round(number, precision = 2)
    BigDecimal.new(number.to_s).round(precision).to_f
  end

  def number_to_percentage(number, precision = 2)
    "#{round(number * 100)}%"
  end

  def confidence_level(z_score)
    return z_score if z_score.is_a? String

    z = round(z_score.to_s.to_f, 3).abs

    if z == 0.0
      'No Change'
    elsif z < 1.645
      'no confidence'
    elsif z < 1.96
      '95% confidence'
    elsif z < 2.57
      '99% confidence'
    else
      '99.9% confidence'
    end
  end

  def diff_percent(experiment, alternative)
    if experiment.control.conversion_rate > 0 && !alternative.control?
      if alternative.conversion_rate > experiment.control.conversion_rate
        "(+#{number_to_percentage((alternative.conversion_rate/experiment.control.conversion_rate)-1)})"
      elsif alternative.conversion_rate < experiment.control.conversion_rate
        "(#{number_to_percentage((alternative.conversion_rate/experiment.control.conversion_rate)-1)})"
      end
    end
  end

end
