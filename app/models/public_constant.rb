module PublicConstant
  extend ActiveSupport::Concern
  ST_ALL = -1
  ST_NEW = 0
  ST_APPROVED = 1
  ST_DELETE = 2
  ST_REJECT = 3

  SEARCH_STATE_TYPE_HASH={
      '全部'=>ST_ALL,
      '新增'=>ST_NEW,
      '通过'=>ST_APPROVED,
      '删除'=>ST_DELETE,
      '拒绝'=>ST_REJECT
  }

  STATE_TYPE_HASH={
      '新增'=>ST_NEW,
      '通过'=>ST_APPROVED,
      '删除'=>ST_DELETE,
      '拒绝'=>ST_REJECT
  }

  STATE_TYPE_HASH_INVERT = STATE_TYPE_HASH.invert

  included do
    scope :approved, -> { where(:state=>ST_APPROVED)}

    scope :by_state, ->(state) { where(:state=>state) if state.present? and  state.to_i > -1}

    scope :order_created_desc, ->{ order('created_at desc')}
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def rand_int(from, to)
      rand_in_range(from, to).to_i
    end

    def rand_price(from, to)
      rand_in_range(from, to).round(2)
    end

    def rand_time(from, to=Time.now)
      Time.at(rand_in_range(from.to_f, to.to_f))
    end

    def rand_in_range(from, to)
      rand * (to - from) + from
    end
  end

end