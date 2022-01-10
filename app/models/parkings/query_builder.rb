class Parkings::QueryBuilder
  include ActiveModel::Model

  SEARCH_RANGE = 1

  SEARCH_PARAMS = %i[
    location
    keyword
  ]

  SEARCH_PARAMS.each { |attr| attr_accessor attr }

  def search
    return [] if search_point.empty?

    latitude = coordinate[0]
    longitude = coordinate[1]
    parkings = Parking.approval

    case keyword
    when 'near'
      parkings.near(search_point_first_coordinates, SEARCH_RANGE)
    when 'inexpensive'
      parkings.order(fee_per_hour: :asc)
              .within_box(SEARCH_RANGE, latitude, longitude)
    when 'capacity'
      parkings.order(capacity: :desc)
              .within_box(SEARCH_RANGE, latitude, longitude)
    else
      parkings
    end
  end

  private

  def search_point
    @search_point ||= Geocoder.search(location)
  end

  def coordinate
    search_point.first.coordinates
  end
end
