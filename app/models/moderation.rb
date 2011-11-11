class Moderation

  def self.get_moderation_time
    time = Content.moderation_time
    # participations_moderation_time = Participation.moderation_time
    #     time = (contents_moderation_time + participations_moderation_time) / 2

    moderation_time = {}

    hours = time.to_i / 3600
    moderation_time[:hours] = "%02d" % hours
    moderation_time[:minutes] = "%02d" % (time.to_i / 60 - hours * 60).to_i

    moderation_time
  end

  def self.not_moderated_count
    contents_count = Content.select([:id, :type, :created_at]).not_rejected.not_moderated.count
    participations_count = Participation.select([:id, :type, :created_at]).not_rejected.not_moderated.count

    contents_count + participations_count
  end

  def self.items_not_moderated(filters = {}, page = 1, per_page = 10)

    order = 'desc'
    if filters[:oldest_first] == 'true'
      order = 'asc'
    end
    order = "created_at #{order}"

    if page && per_page
      offset = (page - 1) * per_page
      offset = 0 if offset < 0
      pagination = "LIMIT #{per_page} OFFSET #{offset}"
    end

    items = User.connection.select_all(<<-SQL
      (#{Content.select([:id, :type, :created_at]).not_rejected.not_moderated.to_sql})
      UNION
      (#{Participation.select([:id, :type, :created_at]).not_rejected.not_moderated.to_sql})
      ORDER BY #{order}
      #{pagination}
    SQL
    ).map{|i| i['type'].constantize.find(i['id'])}

    items
  end

end
