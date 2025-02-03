ReportsKit.configure do |config|
  config.autocomplete_results_method = lambda do |params:, context_record:, relation:|
    query = params[:q]
    if relation.column_names.include?("name")
      results = relation.where('name ILIKE ?', "%#{query}%").order('name').limit(10)
    else
      results = relation.where('first_name ILIKE ? OR last_name ILIKE ?', "%#{query}%", "%#{query}%").order('last_name').limit(10)
    end
    results.map do |result|
      {
        id: result.id,
        text: "#{result.name}"
      }
    end
  end
end