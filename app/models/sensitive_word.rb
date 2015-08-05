class SensitiveWord < ActiveRecord::Base
  # attr_accessible :word

  scope :all_words, ->{select('word')}

  scope :by_word, proc {|word| where('word like ?', "%#{word}%") if word.present?}


  def self.scope_paginate(params)
    self.by_word(params[:word]).paginate(:page => params[:page], :per_page => 20)
  end


  def self.word_valid?(txt)
    return false if txt.blank?
    if txt.is_a?(Array)
      self.all_words.each do |sw|
        txt.each do |child_txt|
          if child_txt.include? sw.word
            return false
          end
        end
      end
    else
      self.all_words.each do |sw|
        if txt.include? sw.word
          return false
        end
      end
    end

    true
  end
end