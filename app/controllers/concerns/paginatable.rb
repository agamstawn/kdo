module Paginatable
  Page = Struct.new(:records, :page, :per_page, :total_count, :total_pages, keyword_init: true)

  private

  def paginate(scope)
    page = [params.fetch(:page, 1).to_i, 1].max
    per_page = [[params.fetch(:per_page, 10).to_i, 1].max, 50].min
    total_count = scope.count

    Page.new(records: scope.offset((page - 1) * per_page).limit(per_page), page: page, per_page: per_page, total_count: total_count, total_pages: [(total_count.to_f / per_page).ceil, 1].max)
  end

  def render_collection(scope, include: nil)
    collection = paginate(scope)
    render json: { data: collection.records.as_json(include: include), meta: collection.to_h.except(:records) }
  end
end
