#encoding: UTF-8
module Irekia
  module StreamsUpdater
    attr_accessor :to_update_public_streams, :to_update_private_streams, :to_notificate

    @just_created = false
    @just_created = true
    @to_update_public_streams = @to_update_private_streams = @to_notificate = @to_update_private_streams_ids = nil


    def just_created=(value)
      @just_created = value
    end

    def just_created?
      @just_created == true
    end

    def to_update_private_streams_ids=(ids)
      @to_update_private_streams_ids = ids
    end

    def to_update_private_streams_ids
      @to_update_private_streams_ids
    end

    def update_streams(content_or_participation = nil)
      item = content_or_participation || self

      # if content is not moderated, we don't need to update *all* users
      # private streams. We just need to update the content author private
      # stream
      if item.not_moderated?
        item.to_update_private_streams = [author]
      end

      data_for_streams = OpenStruct.new(
        :event_id         => item.id,
        :event_type       => item.class.name,
        :author_id        => (item.author.id rescue nil),
        :published_at     => item.published_at,
        :moderated        => item.moderated,
        :message          => item.to_json
      )


      # new content, created by citizens or politicians from the regular
      # application layout
      if item.just_created?
        # create public stream for users
        columns = [:user_id, :event_id, :event_type, :author_id, :published_at, :moderated, :message]
        values  = item.to_update_public_streams.select{|item| item.is_a?(User)}.map{|user| [user.id, data_for_streams.event_id, data_for_streams.event_type, data_for_streams.author_id, data_for_streams.published_at, data_for_streams.moderated, data_for_streams.message]}
        UserPublicStream.import columns, values, :validate => false

        # create public stream for areas
        columns = [:area_id, :event_id, :event_type, :author_id, :published_at, :moderated, :message]
        values  = item.to_update_public_streams.select{|item| item.is_a?(Area)}.map{|area| [area.id, data_for_streams.event_id, data_for_streams.event_type, data_for_streams.author_id, data_for_streams.published_at, data_for_streams.moderated, data_for_streams.message]}
        AreaPublicStream.import columns, values, :validate => false

        # create streams data for users dashbards. If content was generated by
        # a citizen, it's not moderated and it'll only update the author
        # private stream
        item.to_update_private_streams_ids = item.to_update_private_streams.map(&:id).compact.uniq

        columns = [:user_id, :event_id, :event_type, :author_id, :published_at, :moderated, :message]
        values = item.to_update_private_streams_ids.map{|user_id| [user_id, data_for_streams.event_id, data_for_streams.event_type, data_for_streams.author_id, data_for_streams.published_at, data_for_streams.moderated, data_for_streams.message]}


        UserPrivateStream.import columns, values, :validate => false

      # content already exists, updated by administrators from the administration
      # app
      else
        # we need to update previously created public streams for users...
        UserPublicStream.where(
          :event_id   => data_for_streams.event_id,
          :event_type => data_for_streams.event_type,
          :user_id    => item.to_update_public_streams.compact.select{|item| item.is_a?(User)}.uniq.map(&:id)
        ).update_all(
          :published_at => data_for_streams.published_at,
          :message      => data_for_streams.message,
          :author_id    => data_for_streams.author_id,
          :moderated    => data_for_streams.moderated
        )
        # ... and for areas
        AreaPublicStream.where(
          :event_id   => data_for_streams.event_id,
          :event_type => data_for_streams.event_type,
          :area_id    => item.to_update_public_streams.compact.select{|item| item.is_a?(Area)}.uniq.map(&:id)
        ).update_all(
          :published_at => data_for_streams.published_at,
          :message      => data_for_streams.message,
          :author_id    => data_for_streams.author_id,
          :moderated    => data_for_streams.moderated
        )
        # Now it's time to update user private streams after the moderation
        # was done

        item.to_update_private_streams_ids = user_ids = item.to_update_private_streams.map(&:id).compact.uniq

        # If is content generated by a citizen, there would be only one
        # private stream: the author's private stream
        # Otherwise, this method will update all streams
        to_update = UserPrivateStream.where(
          :event_id   => data_for_streams.event_id,
          :event_type => data_for_streams.event_type,
          :user_id    => user_ids
        )

        to_update.update_all(
          :published_at => data_for_streams.published_at,
          :message      => data_for_streams.message,
          :author_id    => data_for_streams.author_id,
          :moderated    => data_for_streams.moderated
        )


        # Only in case this content was generated by a citizen: we need to create
        # private streams for each users
        to_insert = user_ids - to_update.map(&:user_id)
        columns = [:user_id, :event_id, :event_type, :author_id, :published_at, :moderated, :message]
        values = to_insert.map{|user_id| [user_id, data_for_streams.event_id, data_for_streams.event_type, data_for_streams.author_id, data_for_streams.published_at, data_for_streams.moderated, data_for_streams.message]}

        UserPrivateStream.import columns, values, :validate => false

      end

      update_counters(item)
      send_notifications(item)
      send_mail
    end

    def update_counters(item)
      return unless item.moderated?

      Area
      .where(:id => item.to_update_public_streams.compact.select{|area_or_user| area_or_user.is_a?(Area)}.map(&:id))
      .update_all("#{item.class.name.underscore.pluralize}_count = (#{item.class.name.underscore.pluralize}_count + 1)")

      User
      .where(:id => item.to_update_public_streams.compact.select{|area_or_user| area_or_user.is_a?(User)}.map(&:id))
      .update_all("#{item.class.name.underscore.pluralize}_count = (#{item.class.name.underscore.pluralize}_count + 1)")

      User
      .where(:id => item.to_update_private_streams_ids)
      .update_all(<<-SQL
        private_#{item.class.name.underscore.pluralize}_count = (private_#{item.class.name.underscore.pluralize}_count + 1)
      SQL
      )

    end

    def send_notifications(item)
      return unless item.moderated?

      to_notificate_ids = item.to_notificate.map(&:id)

      columns = [:user_id, :item_type, :item_id, :parent_id, :parent_type]
      values = to_notificate_ids.map{|user_id| [user_id, item.class.name, item.id, item.parent.try(:id), item.parent.try(:class).try(:name)]}

      Notification.import columns, values, :validate => false

      User
      .where(:id => to_notificate_ids)
      .update_all(<<-SQL
        new_#{item.class.name.underscore.pluralize}_count = (new_#{item.class.name.underscore.pluralize}_count + 1)
      SQL
      )

    end

  end
end
