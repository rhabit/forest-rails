module ForestLiana
  class BaseGetter
    def get_collection(collection_name)
      ForestLiana.apimap.find { |collection| collection.name.to_s == collection_name }
    end

    def get_resource
      use_act_as_paranoid = @resource.instance_methods
        .include? :really_destroyed?

      # NOTICE: Do not unscope with the paranoia gem to prevent the retrieval
      #         of deleted records.
      use_act_as_paranoid ? @resource : @resource
    end

    def includes_for_serialization
      includes_initial = @includes
      includes_for_smart_belongs_to = @collection.fields_smart_belongs_to.map { |field| field[:field] }

      if @field_names_requested
        includes_for_smart_belongs_to = includes_for_smart_belongs_to & @field_names_requested
      end

      includes_initial.concat(includes_for_smart_belongs_to).map(&:to_s)
    end

    private

    def compute_includes
      @includes = ForestLiana::QueryHelper.get_one_association_names_symbol(@resource)
    end
  end
end
