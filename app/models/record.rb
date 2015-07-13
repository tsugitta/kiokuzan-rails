class Record < ActiveRecord::Base
  validate :has_all_columns?,
           :has_valid_hash_value?,
           :is_best_score?
  after_create :remove_past_record

  scope :rank_order, -> { order(score: :asc) }
  scope :old_records, -> { where('created_at < ?', Date.today - 7) }

  def self.count_all(type)
    Record.where(type: type).count
  end

  def self.delete_old_records
    Record.old_records.destroy_all
  end

  def has_all_columns?
    unless name.present? &&
           score.present? &&
           identity.present? &&
           hash_value.present? &&
           type.present?
      errors.add(:illegal_post, "error")
    end
  end

  def has_valid_hash_value?
    unless hash_value == get_hash_value
      errors.add(:illegal_post, "error")
    end
  end

  def is_best_score?
    if best_record = Record.where(identity: identity, type: type)
             .find_by('score <= ?', score)
      errors.add(:best_score,
        "Your #{best_record.get_time_score} (rank: #{best_record.get_ranking}/#{Record.count_all(self.type)}) (scored at #{best_record.created_at.strftime("%-m/%-d")}) is faster than this.\nThe score will be kept for a week.")
    end
  end

  def get_ranking
    Record.where(type: type).where('score < ?', score).count + 1
  end

  def remove_past_record
    record = Record.find_by(identity: identity, type: type)
    if record && record != self
      record.destroy
    end
  end

  def get_hash_value
    score * 123 + name.length
  end

  def get_time_score
    ms = score % 100
    s = (score - ms) / 100 % 60
    m = (score - ms - s) / 6000 % 3600
    sprintf("%02d:%02d.%02d", m, s, ms)
  end
end
